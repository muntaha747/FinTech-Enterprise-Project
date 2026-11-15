output "vpc_id" {
  value = aws_vpc.sample.id
}

output "amiid" {
    value = var.amiid
}

output "ec2_id" {
    value = aws_instance.ec2_instance.id
}
