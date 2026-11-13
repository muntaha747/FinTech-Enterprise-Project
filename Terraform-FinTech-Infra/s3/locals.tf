# locals.tf: values WORKED OUT from the variables, so main.tf only reads locals.

locals {
  # Tags added to every bucket
  common_tags = {
    Project = var.project_name
    Stack   = var.stack_name
  }

  environment  = var.environment
  bucket_names = var.bucket_names
}
