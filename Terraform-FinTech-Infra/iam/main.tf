# main.tf: WHAT to build. Every value comes from locals.tf.

# Reads the AWS account ID of the credentials you are using (a lookup, not a variable)
data "aws_caller_identity" "current" {}

# The module runs once for each environment in terraform.tfvars (role_sets).
# Inside the module call, each.key is the environment name (e.g. "qa") and each.value is its settings.
module "iam_roles" {
  source   = "../modules/iam-roles"
  for_each = local.role_sets

  account_id           = local.account_id
  env_type             = each.key
  enable_platform_role = each.value.enable_platform_role
  enable_product_role  = each.value.enable_product_role
  enable_cicd_role     = each.value.enable_cicd_role
}
