# locals.tf: values WORKED OUT from the variables and lookups.

locals {
  # Tags added to every resource
  common_tags = {
    Project = var.project_name
    Stack   = var.stack_name
  }

  # Networking outputs are maps: VPC name => value. Pick the VPC this cluster lives in.
  networking         = data.terraform_remote_state.networking.outputs
  private_subnet_ids = local.networking.private_subnet_ids[var.vpc_name]
  cluster_sg_id      = local.networking.private_security_group_ids[var.vpc_name]
}
