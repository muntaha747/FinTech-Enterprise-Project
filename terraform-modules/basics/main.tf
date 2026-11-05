provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "basics-ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
}

resource "aws_eip" "basics-eip" {
  instance = aws_instance.basics-ec2.id
}

resource "aws_s3_bucket" "basics-s3" {
  bucket = "basics-s3-bucket-fintech-project"
}
