# locals.tf: values WORKED OUT once and reused.

locals {
  # Extra tags added to every bucket
  common_tags = {
    Project = "FinTech-Enterprise-Project"
    Stack   = "s3"
  }
}
