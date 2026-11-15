# provider "aws" {
#   region = var.config_values.region
# }

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

# variable "ingress_values" {
#   type    = tuple([number, string, number])
#   default = [22, "tcp", 443]
# }

# resource "aws_security_group" "allow_tls" {
#   name   = "allow_tls"
#   vpc_id = aws_vpc.main.id
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = aws_vpc.main.cidr_block
#   from_port         = var.ingress_values[0]
#   ip_protocol       = var.ingress_values[1]
#   to_port           = var.ingress_values[2]
# }

# ################################ Object (Dictionary) ################################
# variable "config_values" {
#   type = object({
#     region         = string
#     monitoring     = bool
#     instance_count = number
#     instance_type  = string
#   })
#   default = {
#     region         = "us-east-1"
#     monitoring     = true
#     instance_count = 3
#     instance_type  = "t3.micro"
#   }
# }

# ################################ AMI lookup ################################
# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-*-x86_64"]
#   }
# }

# ################################ AWS Instance ################################
# resource "aws_instance" "ec2_instance" {
#   count         = var.config_values.instance_count
#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = var.config_values.instance_type
#   monitoring    = var.config_values.monitoring
# }