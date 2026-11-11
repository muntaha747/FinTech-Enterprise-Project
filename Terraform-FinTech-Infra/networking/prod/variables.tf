# variables.tf: the INPUTS this stack accepts. Values are set in terraform.tfvars.

variable "region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "environment" {
  description = "Environment name, e.g. prod"
  type        = string
}

variable "org" {
  description = "Organisation tag added to resources"
  type        = string
}

variable "azs" {
  description = "Availability Zones the subnets are spread across"
  type        = list(string)
}

variable "tgw_route_cidr" {
  description = "One route that covers every VPC CIDR, sent to the Transit Gateway"
  type        = string
}

variable "vpcs" {
  description = "One entry per VPC to create"
  type = map(object({
    cidr                = string
    public_subnets      = list(string)
    private_subnets     = list(string)
    enable_nat_gateway  = bool
    gateway_endpoints   = list(string)
    interface_endpoints = list(string)
  }))
}
