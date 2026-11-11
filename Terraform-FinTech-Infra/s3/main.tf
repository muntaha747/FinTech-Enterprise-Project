# main.tf: WHAT to build. All values are written directly here.

module "infrastructure_compliance_storage" {
  source = "../modules/s3-bucket"

  environment = "production"

  bucket_names = [
    "fintech-dvc-data-lake",
    "fintech-applog",
  ]

  tags = {
    Project = "FinTech-Enterprise-Project"
    Stack   = "s3"
  }
}
