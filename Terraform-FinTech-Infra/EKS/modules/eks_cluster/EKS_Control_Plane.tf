# EKS_Control_Plane.tf: the Kubernetes control plane and who is allowed to log in to it.

############################ Secrets encryption key ############################
# CHECKOV FIX (CKV_AWS_58)
# WHAT: added a KMS key and told EKS to encrypt Kubernetes Secrets with it (encryption_config below).
# WHY:  without it, Secrets (passwords, API tokens) are only base64-encoded inside etcd.
#       With envelope encryption they are unreadable without this key, even from an etcd backup.
resource "aws_kms_key" "eks_secrets" {
  # checkov:skip=CKV2_AWS_64: Uses the default key policy (the account's IAM policies control the key), which is what EKS expects
  description             = "Encrypts Kubernetes Secrets of ${var.cluster_name}"
  enable_key_rotation     = true # AWS rotates the key material every year
  deletion_window_in_days = var.kms_deletion_window_days
  tags                    = merge(local.common_tags, { Name = "${var.cluster_name}-secrets-key" })
}

############################ Control plane logs ############################
# CHECKOV FIX (CKV_AWS_37)
# WHAT: turned on all five control plane log types (enabled_cluster_log_types below) and created
#       the log group here, so Terraform sets its retention and deletes it on destroy.
# WHY:  the audit log shows who did what in the cluster (kubectl, pods, tokens). Without it there
#       is nothing to investigate after an incident.
resource "aws_cloudwatch_log_group" "eks_cluster" {
  # checkov:skip=CKV_AWS_158: Log group uses CloudWatch's default encryption; a customer KMS key needs its own key policy and is left for a later hardening step
  name              = "/aws/eks/${var.cluster_name}/cluster" # EKS always writes to this exact name
  retention_in_days = var.cluster_log_retention_days
  tags              = merge(local.common_tags, { Name = "${var.cluster_name}-control-plane-logs" })
}

############################ EKS cluster (control plane) ############################
resource "aws_eks_cluster" "eks_control_plane" {
  # CHECKOV SKIPS: three checks are not fixed on purpose.
  # checkov:skip=CKV_AWS_39: The public endpoint stays on because the GitHub-hosted runner and the engineer's machine are outside the VPC and must reach the API
  # checkov:skip=CKV_AWS_38: GitHub-hosted runners have no fixed IP range to allow-list; access is still protected by IAM authentication and EKS access entries
  # checkov:skip=CKV_AWS_339: Kubernetes 1.36 is a current EKS version; this Checkov release's list of supported versions is older
  name                          = var.cluster_name
  role_arn                      = aws_iam_role.eks_fintech_cluster_role.arn
  version                       = var.cluster_version
  bootstrap_self_managed_addons = true                  # installs CoreDNS, kube-proxy and the VPC CNI
  enabled_cluster_log_types     = var.cluster_log_types # CHECKOV FIX (CKV_AWS_37): api, audit, authenticator, controllerManager, scheduler

  # The control plane's network cards go into the private subnets of the App VPC
  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [var.cluster_security_group_id]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }

  # "API" = logins are managed with EKS access entries (no aws-auth ConfigMap).
  # Whoever creates the cluster automatically becomes cluster-admin.
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # CHECKOV FIX (CKV_AWS_58): encrypt Kubernetes Secrets with the KMS key created above
  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = aws_kms_key.eks_secrets.arn
    }
  }

  tags = merge(local.common_tags, { Name = "EKS-Control-Plane-${var.cluster_name}" })

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment,
    aws_cloudwatch_log_group.eks_cluster, # the log group must exist first, or EKS creates its own
  ]
}

############################ Extra cluster admins ############################
# Whoever runs Terraform (root locally, or the GitHub Actions role in CI) already gets
# cluster-admin from bootstrap_cluster_creator_admin_permissions = true.
# Every OTHER principal in var.cluster_admin_arns gets an access entry here, so you keep
# kubectl access no matter who created the cluster.

data "aws_caller_identity" "current_aws_user" {}

# Turns the caller's session ARN (e.g. assumed-role/.../session) into the real role/user ARN
data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current_aws_user.arn
}

locals {
  # Skip the creator: EKS already made an access entry for it (adding it again fails with 409)
  extra_cluster_admins = toset([
    for arn in var.cluster_admin_arns : arn if arn != data.aws_iam_session_context.current.issuer_arn
  ])
}

# 1. Let each extra admin into the cluster
resource "aws_eks_access_entry" "cluster_admins" {
  for_each      = local.extra_cluster_admins
  cluster_name  = aws_eks_cluster.eks_control_plane.name
  principal_arn = each.value
  type          = "STANDARD"
}

# 2. Give each extra admin full cluster-admin rights
resource "aws_eks_access_policy_association" "cluster_admins" {
  for_each      = local.extra_cluster_admins
  cluster_name  = aws_eks_cluster.eks_control_plane.name
  principal_arn = aws_eks_access_entry.cluster_admins[each.key].principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

############################ DevOps engineer access ############################
# The DevOps role (IAM.tf) is mapped to Kubernetes groups; RBAC inside the cluster decides its rights
resource "aws_eks_access_entry" "hassan_devops_engineer_entry" {
  cluster_name      = aws_eks_cluster.eks_control_plane.name
  principal_arn     = aws_iam_role.hassan_iam_role.arn
  type              = "STANDARD"
  kubernetes_groups = var.devops_kubernetes_groups
}
