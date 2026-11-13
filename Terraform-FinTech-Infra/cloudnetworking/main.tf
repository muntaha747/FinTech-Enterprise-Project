#################### TGW ####################
module "tgw" {
  source       = "./tgw/"
  tgw_name     = var.tgw_name
  Environment  = var.Environment
  Organization = var.Organization
}

#################### VPCs ####################
module "FinTech-VPCs" {
  for_each            = var.vpc_setup
  source              = "./module/"
  vpc_name            = each.key
  vpc_cidr_block      = each.value.cidr
  public_subnet       = each.value.public_subnet
  private_subnet      = each.value.private_subnet
  enable_nat_gateway  = each.value.enable_nat_gateway
  interface_endpoints = each.value.interface_endpoints
  availability_zones  = var.availability_zones
  Environment         = var.Environment
  Organization        = var.Organization
  tgw_id              = module.tgw.tgw_id
  ingress             = each.value.public_ingress
  egress              = each.value.public_egress
  private_ingress     = each.value.private_ingress
  private_egress      = each.value.private_egress
  tags                = local.common_tags
}
