# main.tf: WHAT to build. Every value comes from locals.tf.
# Inside each for_each, each.key is the bucket name, e.g. "fintech-applog".

# 1. Create one bucket per name
resource "aws_s3_bucket" "compliance_bucket" {
  # CHECKOV SKIPS: three checks are not fixed on purpose. Each needs extra infrastructure this project does not have yet.
  # checkov:skip=CKV_AWS_144: Cross-region replication needs a second bucket in another region (planned with disaster recovery)
  # checkov:skip=CKV_AWS_18: Access logging needs a separate log bucket; planned together with CloudTrail
  # checkov:skip=CKV2_AWS_62: Event notifications need a consumer (SNS/SQS/Lambda); nothing reads bucket events yet
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

# CHECKOV FIX (CKV2_AWS_6)
# WHAT: added a Public Access Block with all four switches on.
# WHY:  it makes the bucket impossible to expose publicly, even if someone later adds a
#       public ACL or bucket policy by mistake. Compliance data must never be public.
resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  for_each = local.bucket_set
  bucket   = aws_s3_bucket.compliance_bucket[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CHECKOV FIX (CKV_AWS_145)
# WHAT: default encryption now uses AWS KMS (the AWS-managed S3 key) instead of the basic S3 key.
# WHY:  with KMS every decrypt is permission-checked and recorded in CloudTrail, which
#       auditors expect for financial data. bucket_key_enabled keeps the KMS cost low.
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  for_each = local.bucket_set
  bucket   = aws_s3_bucket.compliance_bucket[each.key].id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = local.sse_algorithm
    }
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

    # CHECKOV FIX (CKV_AWS_300)
    # WHAT: unfinished multipart uploads are deleted after N days.
    # WHY:  a failed large upload leaves hidden parts behind that are billed forever.
    abort_incomplete_multipart_upload {
      days_after_initiation = local.abort_incomplete_upload_days
    }

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
