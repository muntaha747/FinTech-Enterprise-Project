# main.tf: WHAT to build. All values are written directly here.

# Reads the AWS account ID of the credentials you are using (a lookup, not a variable)
data "aws_caller_identity" "current" {}

# The module runs once for each entry below: platform, qa, uat, prod.
# Inside the module call, each.key is the name (e.g. "qa") and each.value is its settings.
module "iam_roles" {
  source = "../modules/iam-roles"

  for_each = {
    platform = { enable_platform_role = true, enable_product_role = false, enable_cicd_role = false } # FinTech-Platform-Admin
    qa       = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }  # AppTeam-qa-Role + CI/CD
    uat      = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }  # AppTeam-uat-Role + CI/CD
    prod     = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }  # AppTeam-prod-Role + CI/CD
  }

  account_id           = data.aws_caller_identity.current.account_id
  env_type             = each.key
  enable_platform_role = each.value.enable_platform_role
  enable_product_role  = each.value.enable_product_role
  enable_cicd_role     = each.value.enable_cicd_role
}
