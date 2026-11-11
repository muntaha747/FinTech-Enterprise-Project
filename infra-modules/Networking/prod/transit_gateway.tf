############################## Transit Gateway - connects all VPCs in local.vpcs ##############################
# Added a VPC in locals.tf and it is automatically attached and routed here.

# 1. The hub router
resource "aws_ec2_transit_gateway" "main" {
  description = "fintech-${local.environment} transit gateway"

  tags = { Name = "fintech-${local.environment}-tgw" }
}

# 2. Plug every VPC into the hub (one private subnet per AZ)
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc" {
  for_each = local.vpcs

  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = module.network[each.key].vpc_id
  subnet_ids         = module.network[each.key].private_subnet_ids_per_az
  tags = { Name = "fintech-${local.environment}-${each.key}-tgw-attachment" }
}

# 3. Private subnets: traffic for other VPCs goes to the hub
resource "aws_route" "private_to_tgw" {
  for_each = local.vpcs
  route_table_id         = module.network[each.key].private_route_table_id
  destination_cidr_block = local.tgw_route_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc]
}

# 4. Public subnets (only VPCs that have them): same route
resource "aws_route" "public_to_tgw" {
  for_each = { for name, vpc in local.vpcs : name => vpc if length(vpc.public_subnets) > 0 }
  route_table_id         = module.network[each.key].public_route_table_id
  destination_cidr_block = local.tgw_route_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc]
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.main.id
}
