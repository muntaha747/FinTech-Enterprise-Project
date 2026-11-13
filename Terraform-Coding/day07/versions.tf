# versions.tf: which Terraform and provider versions this folder needs
terraform {
  # Latest Terraform release (1.17.2). Allows 1.17.x patch updates only.
  required_version = "~> 1.17.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.72.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}