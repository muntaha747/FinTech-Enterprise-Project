terraform {
  # Latest Terraform release (1.17.2). Allows 1.17.x patch updates only.
  required_version = "~> 1.17"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.72"
    }
  }
}
