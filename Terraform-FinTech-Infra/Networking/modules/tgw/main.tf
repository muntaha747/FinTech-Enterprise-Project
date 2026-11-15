# main.tf: the Transit Gateway, the central hub that every VPC of one environment attaches to.

resource "aws_ec2_transit_gateway" "tgw" {
  description = var.tgw_description

  tags = merge(var.tags, {
    Name         = var.tgw_name
    Environment  = var.environment
    Organization = var.organization
  })
}
