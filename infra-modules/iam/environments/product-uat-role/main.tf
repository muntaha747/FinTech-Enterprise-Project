provider "aws" {
  region = "us-east-1"
}

module "iam_roles" {
  source               = "../../child-module"
  account_id           = var.account_id # The ID of this ops account
  enable_product_role  = true           # Enable Dev and CI/CD roles here
  enable_cicd_role     = true
  env_type             = "uat"
}