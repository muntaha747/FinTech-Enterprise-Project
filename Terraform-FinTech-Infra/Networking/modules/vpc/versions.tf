# versions.tf: the Terraform and provider versions this module needs.
# Version pins live here (in the child module), not in the root.

terraform {
  required_version = "~> 1.17" # Terraform 1.17 or any newer 1.x release

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.72"
    }
  }
}
