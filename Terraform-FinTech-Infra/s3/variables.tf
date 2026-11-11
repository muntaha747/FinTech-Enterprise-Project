# variables.tf: the INPUTS this stack accepts. Values are set in terraform.tfvars.

variable "region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "environment" {
  description = "Environment name, e.g. production"
  type        = string
}

variable "bucket_names" {
  description = "Names of the S3 buckets to create (must be globally unique)"
  type        = list(string)
}
