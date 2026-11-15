############################ Cluster Autoscaler ############################
# Cluster Autoscaler watches the cluster and changes the node group sizes:
#   - Pods waiting because there is no room  -> it ADDS nodes (up to max_size)
#   - Nodes sitting empty for a while        -> it REMOVES nodes (down to min_size)
#
# It runs as a pod inside the cluster, so it needs AWS permissions to resize
# the node groups. We give it those permissions with IRSA (see OIDC.tf):
#   1. An IAM policy  = WHAT it is allowed to do
#   2. An IAM role    = WHO may use that policy (only the autoscaler's pod)
#   3. An attachment  = connects the policy to the role
#   4. A Helm release = installs the autoscaler into the cluster


############################ Local values ############################
# The OIDC issuer URL without "https://". IAM trust conditions need it in this form,
# e.g. "oidc.eks.us-east-1.amazonaws.com/id/ABC123".
locals {
  oidc_issuer_host = replace(aws_eks_cluster.eks_control_plane.identity[0].oidc[0].issuer, "https://", "")

  # This AWS account's ID (used to build ARNs in the policy below)
  account_id = data.aws_caller_identity.current_aws_user.account_id

  # Name of the Kubernetes service account the autoscaler pod runs as.
  # Used in two places below, so it is written once here.
  cluster_autoscaler_service_account = "cluster-autoscaler"
}


############################ 1. IAM policy: WHAT it may do ############################
# CHECKOV FIX (CKV_AWS_290, CKV_AWS_355)
# WHAT: split the single "allow everything on *" statement into three statements:
#         - ReadOnly: the Describe/Get actions (AWS only accepts "*" for these)
#         - ReadOwnNodeGroups: eks:DescribeNodegroup, only on THIS cluster's node groups
#         - ScaleOwnNodeGroups: the two actions that CHANGE things, only on this account's
#           Auto Scaling Groups that are tagged as belonging to THIS cluster.
# WHY:  before, the autoscaler could resize or terminate instances in ANY Auto Scaling Group
#       in the account. Now a bug or a stolen token can only touch this cluster's node groups.
# (EKS adds the tag k8s.io/cluster-autoscaler/<cluster-name> = owned to every managed node group.)
# eks:DescribeNodegroup lets it read a node group's labels and taints, which it
# needs to scale a group UP FROM 0 nodes (the green and ML groups start at 0).
resource "aws_iam_policy" "cluster_autoscaler" {
  name = "${var.cluster_name}-Cluster-Autoscaler-Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadOnly"
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
        ]
        Resource = "*"
      },
      {
        Sid      = "ReadOwnNodeGroups"
        Effect   = "Allow"
        Action   = ["eks:DescribeNodegroup"]
        Resource = "arn:aws:eks:${var.region}:${local.account_id}:nodegroup/${var.cluster_name}/*/*"
      },
      {
        Sid    = "ScaleOwnNodeGroups"
        Effect = "Allow"
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
        ]
        Resource = "arn:aws:autoscaling:${var.region}:${local.account_id}:autoScalingGroup:*:autoScalingGroupName/*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
          }
        }
      },
    ]
  })

  tags = merge(local.common_tags, { Name = "${var.cluster_name}-Cluster-Autoscaler-Policy" })
}


############################ 2. IAM role: WHO may use it ############################
# This role can ONLY be used by one pod identity:
#   the "cluster-autoscaler" service account in the "kube-system" namespace
#   of THIS cluster (checked through the cluster's OIDC provider).
# No other pod, user, or machine can take this role.
resource "aws_iam_role" "cluster_autoscaler" {
  name = "${var.cluster_name}-Cluster-Autoscaler-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity" # pods log in with a token, not a password

      # Trust the OIDC provider of our cluster (created in OIDC.tf)
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks_oidc.arn
      }

      # Extra checks on the pod's token:
      #   sub = which service account is asking (must be kube-system/cluster-autoscaler)
      #   aud = who the token is meant for (must be AWS STS)
      Condition = {
        StringEquals = {
          "${local.oidc_issuer_host}:sub" = "system:serviceaccount:kube-system:${local.cluster_autoscaler_service_account}"
          "${local.oidc_issuer_host}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })

  tags = merge(local.common_tags, { Name = "${var.cluster_name}-Cluster-Autoscaler-Role" })
}


############################ 3. Attach the policy to the role ############################
# Without this, the role exists but has no permissions.
resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}


############################ 4. Install the autoscaler with Helm ############################
# Helm is a package manager for Kubernetes. This installs the official
# cluster-autoscaler chart into the kube-system namespace.
# Each entry in "set" overrides one setting of the chart.
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = var.cluster_autoscaler_chart_version

  # If the install fails (e.g. the pod never becomes ready), Helm removes the half-installed
  # release by itself. Without this, the next pipeline run fails with
  # "cannot re-use a name that is still in use".
  atomic = true

  set = [
    # Autoscaler version. Must match the cluster's Kubernetes minor version (1.36 -> v1.36.x).
    {
      name  = "image.tag"
      value = var.cluster_autoscaler_image_tag
    },
    # Find node groups automatically: EKS tags every managed node group's
    # Auto Scaling Group with this cluster's name, and the autoscaler looks for that tag.
    {
      name  = "autoDiscovery.clusterName"
      value = aws_eks_cluster.eks_control_plane.name
    },
    # Region where the Auto Scaling Groups live.
    {
      name  = "awsRegion"
      value = var.region
    },
    # Let the chart create the Kubernetes service account for the pod...
    {
      name  = "rbac.serviceAccount.create"
      value = "true"
    },
    # ...with the exact name the IAM role trusts (step 2).
    {
      name  = "rbac.serviceAccount.name"
      value = local.cluster_autoscaler_service_account
    },
    # Link the service account to the IAM role (this annotation is how IRSA works).
    # The dots inside the key are escaped (\\.) so Helm does not treat them as nesting.
    {
      name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.cluster_autoscaler.arn
    },
    # Keep similar node groups (e.g. blue and green) about the same size when scaling.
    {
      name  = "extraArgs.balance-similar-node-groups"
      value = "true"
    },
    # Allow removing a node even if it runs kube-system pods (they get moved elsewhere).
    {
      name  = "extraArgs.skip-nodes-with-system-pods"
      value = "false"
    },
  ]

  # Install only after:
  #   - the IAM permissions exist (otherwise the pod starts without access), and
  #   - there is at least one node for the autoscaler pod to run on.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_autoscaler,
    aws_eks_node_group.core_data_plane_blue,
  ]
}
