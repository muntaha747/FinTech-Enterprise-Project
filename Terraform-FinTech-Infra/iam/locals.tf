# locals.tf: values WORKED OUT once and reused.

locals {
  # The AWS account we are logged into. No need to type it on the command line.
  account_id = data.aws_caller_identity.current.account_id
}
