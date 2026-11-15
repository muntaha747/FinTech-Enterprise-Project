# variables.tf: every value main.tf uses.

variable "tgw_name" {
  description = "Name of the Transit Gateway"
  type        = string
}

variable "tgw_description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "Central hub for FinTech VPCs"
}

variable "environment" {
  description = "Environment tag value, e.g. Prod"
  type        = string
}

variable "organization" {
  description = "Organization tag value"
  type        = string
}

variable "tags" {
  description = "Extra tags added to the Transit Gateway"
  type        = map(string)
  default     = {}
}
