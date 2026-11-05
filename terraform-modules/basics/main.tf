provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "basics-ec2" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.instance_type
  depends_on    = [aws_s3_bucket.basics-s3]
}

resource "aws_eip" "basics-eip" {
  instance = aws_instance.basics-ec2.id
}

resource "aws_s3_bucket" "basics-s3" {
  bucket = "basics-s3-bucket-fintech-project"
}
