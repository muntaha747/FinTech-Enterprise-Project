provider "aws" {
  region = "us-east-1"
}

module "iam_roles" {
  source              = "../../child-module"
  account_id          = var.account_id # The ID of this prod account
  enable_product_role = true           # AppTeam-prod-Role (read-only in prod, enforced by the module)
  enable_cicd_role    = true           # FinTech-CI-CD-Deployer-prod (GitHub OIDC)
  env_type            = "prod"
}