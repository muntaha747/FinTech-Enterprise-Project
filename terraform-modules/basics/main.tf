provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "basics-ec2" {
  ami           = "ami-0d97d7f07b25dd693"
  instance_type = "t2.micro"
}

resource "aws_eip" "basics-eip" {
  instance = aws_instance.basics-ec2.id
}

resource "aws_s3_bucket" "basics-s3" {
  bucket = "basics-s3-bucket-fintech-project"
}