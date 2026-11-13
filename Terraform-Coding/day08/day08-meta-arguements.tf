
resource "aws_s3_bucket" "bucket1" {
    bucket = "my-muntaha-unique-bucket"
    tags = { 
        Name = "my-bucket"
    }
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}



resource "aws_security_group" "allow_tls" {
  name   = "allow_tls"
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = var.ingress_values[0]
  ip_protocol       = var.ingress_values[1]
  to_port           = var.ingress_values[2]
}



################################ AWS Instance ################################
resource "aws_instance" "ec2_instance" {
  count         = var.config_values.instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.config_values.instance_type
  monitoring    = var.config_values.monitoring
}