# main.tf: values are written directly here.
# Only 3 inputs come from the root module: var.bucket_names, var.environment, var.tags.
# Inside each loop, each.key is the bucket name, e.g. "fintech-applog".

# 1. Create one bucket per name
resource "aws_s3_bucket" "compliance_bucket" {
  for_each = toset(var.bucket_names)
  bucket   = each.key

  tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform-Platform-Engine"
    },
    var.tags
  )
}

# 2. Turn on versioning for each bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each = toset(var.bucket_names)
  bucket   = aws_s3_bucket.compliance_bucket[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Lifecycle rules for each bucket
resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  for_each = toset(var.bucket_names)
  bucket   = aws_s3_bucket.compliance_bucket[each.key].id

  rule {
    id     = "platform-compliance-lifecycle-policy"
    status = "Enabled"

    filter {} # apply the rule to every object in the bucket

    # After 30 days: move to Infrequent Access (cheaper)
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # After 180 days: move to Glacier (archive)
    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    # After 2 years: delete
    expiration {
      days = 730
    }

    # Old versions: archive after 90 days, delete after 180 days
    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 180
    }
  }
}
