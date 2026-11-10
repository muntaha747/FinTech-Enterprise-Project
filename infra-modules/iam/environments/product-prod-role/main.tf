provider "aws" {
  region = "us-east-1"
}

module "iam_roles" {
  source               = "../../child-modules"
  account_id           = var.account_id # The ID of this ops account
  enable_prod_role = true           # Only enable the Admin/Guardian roles here
  env_type             = "prod"
}