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

resource "aws_eks_cluster" "EKS-Control-Plane" {
  name                          = var.cluster_name
  role_arn                      = aws_iam_role.EKS-FinTech-Cluster-Role.arn
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

  depends_on = [aws_iam_role_policy_attachment.EKS_CLUSTER_POLICY_ATTACHMENT]
}

data "aws_caller_identity" "current_aws_user" {}

resource "aws_eks_access_entry" "root_admin_entry" {
  cluster_name  = aws_eks_cluster.EKS-Control-Plane.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current_aws_user.account_id}:root"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "root_admin_policy" {
  cluster_name  = aws_eks_cluster.EKS-Control-Plane.name
  principal_arn = aws_eks_access_entry.root_admin_entry.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "Hassan-devops-engineer-entry" {
  cluster_name      = aws_eks_cluster.EKS-Control-Plane.name
  principal_arn     = aws_iam_role.Hassan-iam-role.arn
  type              = "STANDARD"
  kubernetes_groups = ["hassan-devops"]
}