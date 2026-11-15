# main.tf: WHAT to build. Every value comes from locals.tf.
# Inside each for_each, each.key is the bucket name, e.g. "fintech-applog".

# 1. Create one bucket per name
resource "aws_s3_bucket" "compliance_bucket" {
  for_each = local.bucket_set
  bucket   = each.key
  tags     = local.bucket_tags
}

# 2. Turn on versioning for each bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each = local.bucket_set
  bucket   = aws_s3_bucket.compliance_bucket[each.key].id

  versioning_configuration {
    status = local.versioning_status
  }
}

# 3. Lifecycle rules for each bucket
resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  for_each = local.bucket_set
  bucket   = aws_s3_bucket.compliance_bucket[each.key].id

  rule {
    id     = local.lifecycle_rule_id
    status = local.lifecycle_rule_status

    filter {} # apply the rule to every object in the bucket

    # Move to the cheaper infrequent access tier after N days
    transition {
      days          = local.infrequent_access_days
      storage_class = local.infrequent_access_storage_class
    }

    # Move to the archive tier after N days
    transition {
      days          = local.archive_days
      storage_class = local.archive_storage_class
    }

    # Delete after N days
    expiration {
      days = local.expiration_days
    }

    # Old versions: archive after N days
    noncurrent_version_transition {
      noncurrent_days = local.noncurrent_archive_days
      storage_class   = local.archive_storage_class
    }

    # Old versions: delete after N days
    noncurrent_version_expiration {
      noncurrent_days = local.noncurrent_expiration_days
    }
  }
}
