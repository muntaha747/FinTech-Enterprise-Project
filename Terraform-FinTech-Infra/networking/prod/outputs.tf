# outputs.tf: values printed after apply, and readable by other stacks.

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main.id
}

output "vpc_ids" {
  description = "VPC ID for each VPC, e.g. { app = \"vpc-123\" }"
  value       = { for name, net in module.network : name => net.vpc_id }
}
