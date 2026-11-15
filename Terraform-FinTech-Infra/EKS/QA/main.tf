# main.tf: WHAT to build. Values come from terraform.tfvars (through variables.tf) and locals.tf.

# Reads the outputs of this environment's Networking stack (read-only).
# This is how EKS finds the VPC subnets, so Networking must be applied first.
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = var.networking_state_bucket
    key    = var.networking_state_key
    region = var.region
  }
}

# The whole EKS platform: control plane, node groups, IAM, OIDC and Cluster Autoscaler
module "eks_cluster" {
  source = "../modules/eks_cluster"

  region      = var.region
  environment = var.environment
  tags        = local.common_tags

  # Control plane
  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  private_subnet_ids        = local.private_subnet_ids
  cluster_security_group_id = local.cluster_sg_id
  endpoint_private_access   = var.endpoint_private_access
  endpoint_public_access    = var.endpoint_public_access
  cluster_admin_arns        = var.cluster_admin_arns
  devops_user_name          = var.devops_user_name

  # Node groups
  node_color          = var.node_color
  data_plane_blue     = var.data_plane_blue
  data_plane_green    = var.data_plane_green
  ml_data_plane_blue  = var.ml_data_plane_blue
  ml_data_plane_green = var.ml_data_plane_green

  # Cluster Autoscaler
  cluster_autoscaler_chart_version = var.cluster_autoscaler_chart_version
  cluster_autoscaler_image_tag     = var.cluster_autoscaler_image_tag
}
