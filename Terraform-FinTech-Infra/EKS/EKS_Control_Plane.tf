data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "fintech-project-statefile-bucket"
    key    = "cloudnetworking/prod/networking.tfstate"
    region = "us-east-1"
  }
}

data "aws_subnets" "control_plane" {
  filter {
    name   = "subnet-id"
    values = data.terraform_remote_state.networking.outputs.private_subnet_ids["FinTech-App"]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"]
  }
}

resource "aws_eks_cluster" "eks_control_plane" {
  name                          = var.cluster_name
  role_arn                      = aws_iam_role.eks_fintech_cluster_role.arn
  version                       = var.cluster_version
  bootstrap_self_managed_addons = true

  vpc_config {
    subnet_ids              = data.aws_subnets.control_plane.ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = [data.terraform_remote_state.networking.outputs.private_security_group_ids["FinTech-App"]]
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = "EKS-Control-Plane-${var.cluster_name}"
    Env  = var.env
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy_attachment]
}

data "aws_caller_identity" "current_aws_user" {}

############################ Extra cluster admins ############################
# Whoever runs Terraform (root locally, or the GitHub Actions role in CI) already gets
# cluster-admin from bootstrap_cluster_creator_admin_permissions = true.
# Every OTHER principal in var.cluster_admin_arns gets an access entry here, so you keep
# kubectl access no matter who created the cluster.

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

resource "aws_eks_access_entry" "hassan_devops_engineer_entry" {
  cluster_name      = aws_eks_cluster.eks_control_plane.name
  principal_arn     = aws_iam_role.hassan_iam_role.arn
  type              = "STANDARD"
  kubernetes_groups = ["hassan-devops"]
}