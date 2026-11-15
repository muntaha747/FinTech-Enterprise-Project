# IAM.tf: the IAM roles the cluster and its nodes run as, plus one DevOps engineer login.

locals {
  # Tags added to every resource in this module
  common_tags = merge(var.tags, {
    Environment = var.environment
  })
}

############################ EKS cluster role ############################
# The EKS control plane uses this role to manage AWS resources for the cluster
resource "aws_iam_role" "eks_fintech_cluster_role" {
  name = "${var.cluster_name}-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "eks.amazonaws.com" } # only the EKS service may use this role
    }]
  })

  tags = merge(local.common_tags, { Name = "${var.cluster_name}-Role" })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_fintech_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

############################ Worker node role ############################
# Every EC2 worker node (all node groups) runs as this role
resource "aws_iam_role" "eks_fintech_worker_node_role" {
  name = "${var.cluster_name}-Worker-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" } # only EC2 instances may use this role
    }]
  })

  tags = merge(local.common_tags, { Name = "${var.cluster_name}-Worker-Role" })
}

# The three AWS managed policies every EKS worker node needs:
# join the cluster, manage pod networking (CNI), and pull images from ECR.
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  role       = aws_iam_role.eks_fintech_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  role       = aws_iam_role.eks_fintech_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  role       = aws_iam_role.eks_fintech_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

############################ DevOps engineer: IAM user + role ############################
# The user has ONE permission: assume the role below.
# The role is what gets access to the cluster (see the access entry in EKS_Control_Plane.tf).
resource "aws_iam_user" "hassan" {
  # checkov:skip=CKV_AWS_273: IAM user kept for the course exercise; replacing it with IAM Identity Center (SSO) is the next item on the roadmap
  name = var.devops_user_name
  tags = merge(local.common_tags, { Name = var.devops_user_name })
}

resource "aws_iam_role" "hassan_iam_role" {
  name = "${var.devops_user_name}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { AWS = aws_iam_user.hassan.arn } # only this one user may use the role
    }]
  })

  tags = merge(local.common_tags, { Name = "${var.devops_user_name}-iam-role" })
}

# Lets the user assume the role (and nothing else)
resource "aws_iam_user_policy" "iam_user_and_role_attachment" {
  # checkov:skip=CKV_AWS_40: The user's only permission is to assume one role; a group for a single user would add resources without adding safety
  name = "${var.devops_user_name}-assume-role"
  user = aws_iam_user.hassan.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = aws_iam_role.hassan_iam_role.arn
    }]
  })
}
