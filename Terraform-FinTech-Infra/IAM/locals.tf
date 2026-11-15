# locals.tf: values WORKED OUT from the variables and lookups, so main.tf only reads locals.

locals {
  # The AWS account we are logged into. No need to type it on the command line.
  account_id = data.aws_caller_identity.current.account_id

  # Which roles each environment gets (from terraform.tfvars)
  role_sets = var.role_sets
}
