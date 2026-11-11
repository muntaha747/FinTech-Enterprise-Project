# locals.tf: values WORKED OUT from the inputs, so main.tf stays short.

locals {
  # Name prefix for every resource, e.g. "fintech-prod"
  name_prefix = "fintech-${var.environment}"

  # Only the VPCs that have public subnets (edge, app, ops).
  # Read as: "for each VPC (name = its key, vpc = its settings),
  #           keep it if it has at least one public subnet".
  vpcs_with_public_subnets = {
    for name, vpc in var.vpcs : name => vpc if length(vpc.public_subnets) > 0
  }
}
