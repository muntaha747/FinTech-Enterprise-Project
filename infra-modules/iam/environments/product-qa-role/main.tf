provider "aws" {
  region = "us-east-1"
}

module "iam_roles" {
  source               = "../../child-modules"
  account_id           = var.account_id # The ID of this ops account
  enable_product_role = true           # Only enable the Admin/Guardian roles here
  enable_cicd_role = true
  env_type             = "qa"
}