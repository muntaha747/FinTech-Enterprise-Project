# versions.tf: the Terraform and AWS provider versions this module needs.
# Version pins live here (in the child module), not in the root.

terraform {
  required_version = ">= 1.17.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.72"
    }
  }
}
