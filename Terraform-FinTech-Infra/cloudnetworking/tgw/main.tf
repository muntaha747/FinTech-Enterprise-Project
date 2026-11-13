#################### Transit Gateway ####################
# One central hub that all FinTech VPCs attach to
resource "aws_ec2_transit_gateway" "tgw" {
  description = var.tgw_description

  tags = {
    Name         = var.tgw_name
    Environment  = var.Environment
    Organization = var.Organization
  }
}
