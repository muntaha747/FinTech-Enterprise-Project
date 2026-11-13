################################## VPC ##################################
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

################################## Subnets ##################################
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private_subnet[*].id
}

################################## Gateways ##################################
output "internet_gateway_id" {
  description = "ID of the internet gateway (null if no public subnets)"
  value       = try(aws_internet_gateway.my_igw[0].id, null)
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway (null if NAT is disabled)"
  value       = try(aws_nat_gateway.nat_gateway[0].id, null)
}

output "nat_public_ip" {
  description = "Public Elastic IP of the NAT gateway (null if NAT is disabled)"
  value       = try(aws_eip.nat_eip[0].public_ip, null)
}

################################## Route Tables ##################################
output "public_route_table_id" {
  description = "ID of the public route table (null if no public subnets)"
  value       = try(aws_route_table.public_route_table[0].id, null)
}

output "private_route_table_id" {
  description = "ID of the private route table (null if no private subnets)"
  value       = try(aws_route_table.private_route_table[0].id, null)
}

################################## Security Groups ##################################
output "public_security_group_id" {
  description = "ID of the public subnet security group (null if no public subnets)"
  value       = try(aws_security_group.public_subnet_sg["public"].id, null)
}

output "private_security_group_id" {
  description = "ID of the private subnet security group (null if no private subnets)"
  value       = try(aws_security_group.private_subnet_sg["private"].id, null)
}

output "endpoint_security_group_id" {
  description = "ID of the security group attached to the interface VPC endpoints"
  value       = aws_security_group.endpoint_sg.id
}

################################## VPC Endpoints ##################################
output "s3_endpoint_id" {
  description = "ID of the S3 gateway VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "interface_endpoint_ids" {
  description = "Map of interface endpoint service name => endpoint ID"
  value       = { for k, ep in aws_vpc_endpoint.interfaces : k => ep.id }
}
