# variables.tf: the INPUTS this stack accepts. Values are set in terraform.tfvars.

variable "region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "project_name" {
  description = "Project tag value on every resource"
  type        = string
}

variable "stack_name" {
  description = "Stack tag value on every resource"
  type        = string
}

variable "Environment" {
  description = "Environment name, e.g. Production"
  type        = string
}

variable "Organization" {
  description = "Organization name tagged on every resource"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones to spread the subnets across"
  type        = list(string)
}

variable "tgw_name" {
  description = "Name of the Transit Gateway"
  type        = string
}

# One entry per VPC: the key is the VPC name, the value is its settings
variable "vpc_setup" {
  description = "Settings for every VPC to create (VPC name => settings)"
  type = map(object({
    cidr                = string
    public_subnet       = list(string)
    private_subnet      = list(string)
    enable_nat_gateway  = bool
    interface_endpoints = list(string)

    public_ingress = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })), [])

    public_egress = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })), [])

    private_ingress = map(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    private_egress = map(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}