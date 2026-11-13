output "tgw_id" {
  description = "ID of the Transit Gateway, passed to every VPC so it can attach"
  value       = aws_ec2_transit_gateway.tgw.id
}
