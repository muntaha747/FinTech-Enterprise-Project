resource "aws_s3_bucket" "backend-statefile-s3" {
  bucket        = "fintech-project-statefile-bucket"
  region        = "us-east-1"
  force_destroy = false
  tags = {
  Name = "fintech-project-statefile-bucket" }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.backend-statefile-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}


