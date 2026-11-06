provider "aws" {
    region = "us-east-1"
}

resource "aws_eip" "eip1" {
    instance = var.instance_id
} 