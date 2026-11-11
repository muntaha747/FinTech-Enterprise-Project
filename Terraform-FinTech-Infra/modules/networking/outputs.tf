output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.my_vpc.cidr_block
}

output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "private_subnet_ids_per_az" {
  description = "First private subnet in each AZ (for TGW attachments / interface endpoints)"
  value       = slice(aws_subnet.private_subnet[*].id, 0, 3) # first 3 private subnets = one per AZ
}

output "public_subnet_ids" {
  description = "IDs of the public subnets (empty if the VPC has none)"
  value       = aws_subnet.public_subnet[*].id
}

output "private_route_table_id" {
  description = "ID of the private route table (null if no private subnets)"
  value       = length(aws_route_table.private) > 0 ? aws_route_table.private[0].id : null
}

output "public_route_table_id" {
  description = "ID of the public route table (null if no public subnets)"
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : null
}
