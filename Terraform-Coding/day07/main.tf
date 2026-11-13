resource "aws_vpc" "sample" {
  cidr_block = local.cidr
  tags = {
    Environment = local.environment
    Name        = "${var.environment}-VPC-"
  }
}


resource "aws_instance" "ec2_instance" {
  ami           = "ami-09bf9dfeeb1e9adbc"
  instance_type = "t2.micro"
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-Ec2-Instance"
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = local.bucket_name
  }
}



