# outputs.tf: values printed after apply, and readable by other stacks.
# Each VPC output is a map: VPC name => value.
# "for name, vpc in module.FinTech-VPCs : name => vpc.X" loops over every VPC
# and builds { "FinTech-Edge" = ..., "FinTech-Core" = ... }.

output "tgw_id" {
  description = "ID of the Transit Gateway"
  value       = module.tgw.tgw_id
}

output "vpc_ids" {
  description = "VPC ID per VPC"
  value       = { for name, vpc in module.FinTech-VPCs : name => vpc.vpc_id }
}

output "vpc_cidr_blocks" {
  description = "CIDR block per VPC"
  value       = { for name, vpc in module.FinTech-VPCs : name => vpc.vpc_cidr_block }
}

output "public_subnet_ids" {
  description = "Public subnet IDs per VPC"
  value       = { for name, vpc in module.FinTech-VPCs : name => vpc.public_subnet_ids }
}

output "private_subnet_ids" {
  description = "Private subnet IDs per VPC"
  value       = { for name, vpc in module.FinTech-VPCs : name => vpc.private_subnet_ids }
}

output "nat_public_ips" {
  description = "NAT gateway public IP per VPC (null if NAT is off)"
  value       = { for name, vpc in module.FinTech-VPCs : name => vpc.nat_public_ip }
}

output "private_route_table_ids" {
  description = "Private route table ID per VPC"
  value       = { for name, vpc in module.FinTech-VPCs : name => vpc.private_route_table_id }
}

output "private_security_group_ids" {
  description = "Private security group ID per VPC"
  value       = { for name, vpc in module.FinTech-VPCs : name => vpc.private_security_group_id }
}

output "s3_endpoint_ids" {
  description = "S3 gateway endpoint ID per VPC"
  value       = { for name, vpc in module.FinTech-VPCs : name => vpc.s3_endpoint_id }
}
