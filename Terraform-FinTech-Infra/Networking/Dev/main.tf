# main.tf: WHAT to build. Values come from terraform.tfvars (through variables.tf) and locals.tf.

#################### Transit Gateway ####################
# One hub per environment. Every VPC below attaches to it.
module "tgw" {
  source       = "../modules/tgw"
  tgw_name     = var.tgw_name
  environment  = var.environment
  organization = var.organization
}

#################### VPCs ####################
# The module runs once per entry in var.vpc_setup.
# each.key is the VPC name (e.g. "FinTech-App"), each.value is its settings.
module "fintech_vpcs" {
  source   = "../modules/vpc"
  for_each = var.vpc_setup

  vpc_name            = each.key
  vpc_cidr_block      = each.value.cidr
  public_subnet       = each.value.public_subnet
  private_subnet      = each.value.private_subnet
  enable_nat_gateway  = each.value.enable_nat_gateway
  interface_endpoints = each.value.interface_endpoints
  public_ingress      = each.value.public_ingress
  public_egress       = each.value.public_egress
  private_ingress     = each.value.private_ingress
  private_egress      = each.value.private_egress

  availability_zones = var.availability_zones
  environment        = var.environment
  organization       = var.organization
  tgw_id             = module.tgw.tgw_id
  tags               = local.common_tags
}
