provider "aws" {
  region = "us-east-1"
}

# Invoke your modular compliance bucket creation tier cleanly
module "infrastructure_compliance_storage" {
  source      = "./s3_compliance_bucket/"
  environment = "production"

  # 🎯 DYNAMIC INPUT: Simply add or append bucket name strings to this variable array block
  bucket_names = [
    #"wezvatech-2026-tfstate",
    "fintech-muntaha-dvc-data-lake",
    "fintech-muntaha-applog"
  ]
}

# Output tracking loop maps straight to your terminal screen for verification
output "deployed_infrastructure_storage_arns" {
  value = module.infrastructure_compliance_storage.bucket_arns
}
