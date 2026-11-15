# variables.tf: the INPUTS this stack accepts. Values are set in terraform.tfvars.

variable "region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "project_name" {
  description = "Project tag value on every repository"
  type        = string
}

variable "stack_name" {
  description = "Stack tag value on every repository"
  type        = string
}

variable "repository_names" {
  description = "Names of the ECR repositories to create (one per microservice)"
  type        = list(string)
}

variable "image_mutability" {
  description = "Tag mutability: MUTABLE (a tag can be overwritten) or IMMUTABLE (it cannot)"
  type        = string
}
