# variables.tf: the INPUTS this stack accepts. Values are set in terraform.tfvars.

variable "region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "role_sets" {
  description = "Which roles to create for each environment"
  type = map(object({
    enable_platform_role = bool
    enable_product_role  = bool
    enable_cicd_role     = bool
  }))
}
