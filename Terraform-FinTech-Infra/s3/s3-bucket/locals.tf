# locals.tf: values WORKED OUT from the variables, so main.tf only reads locals.

locals {
  # Tags on every bucket: Environment and ManagedBy first, then any extra tags the root adds
  bucket_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = var.managed_by
    },
    var.tags
  )

  # One bucket per name. for_each needs a set here, not a plain list.
  bucket_set = toset(var.bucket_names)

  # Versioning
  versioning_status = var.versioning_status

  # Lifecycle rule (the rule that moves and deletes objects)
  lifecycle_rule_id               = var.lifecycle_rule_id
  lifecycle_rule_status           = var.lifecycle_rule_status
  infrequent_access_days          = var.infrequent_access_days
  infrequent_access_storage_class = var.infrequent_access_storage_class
  archive_days                    = var.archive_days
  archive_storage_class           = var.archive_storage_class
  expiration_days                 = var.expiration_days
  noncurrent_archive_days         = var.noncurrent_archive_days
  noncurrent_expiration_days      = var.noncurrent_expiration_days
}
