############################## Networking - one module call per VPC ##############################
module "network" {
  source   = "./network"
  for_each = local.vpcs

  name        = "fintech-${local.environment}-${each.key}"
  vpc_name    = each.key
  vpc_cidr    = each.value.cidr
  Environment = local.environment
  org         = local.org

  public_subnets     = each.value.public_subnets
  private_subnets    = each.value.private_subnets
  enable_nat_gateway = each.value.enable_nat_gateway

  # Public SG: HTTPS in from the internet, all traffic out
  sg_public_ingress = {
    https = { description = "HTTPS from internet", from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  }
  sg_public_egress = {
    all = { description = "All outbound", from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  }

  # Private SG: only traffic from inside the same VPC
  sg_private_ingress = {
    vpc = { description = "All traffic from within VPC", from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = [each.value.cidr] }
  }
  sg_private_egress = {
    all = { description = "All outbound", from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  }

  gateway_endpoints   = each.value.gateway_endpoints
  interface_endpoints = each.value.interface_endpoints
}
