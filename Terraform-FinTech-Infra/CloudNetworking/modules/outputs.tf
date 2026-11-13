output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway (null if no public subnets)"
  value       = try(aws_internet_gateway.my_igw[0].id, null)
}
