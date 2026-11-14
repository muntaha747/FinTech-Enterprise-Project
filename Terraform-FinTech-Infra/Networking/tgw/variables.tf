variable "tgw_name" {
  description = "Name of the Transit Gateway"
  type        = string
}

variable "tgw_description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "Central hub for FinTech VPCs"
}

variable "Environment" {
  description = "Environment tag"
  type        = string
}

variable "Organization" {
  description = "Organization tag"
  type        = string
}
