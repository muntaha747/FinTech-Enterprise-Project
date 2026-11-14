locals {
  # Tags added to every bucket
  common_tags = {
    Project = var.project_name
    Stack   = var.stack_name
  }
  environment  = var.environment
  bucket_names = var.bucket_names
}
