resource "aws_s3_bucket" "" {
    bucket = "my-first-bucket-with-tutorials-muntaha"
    tags = {
        Name        = "My bucket"
        Environment = "Dev"
  }
}