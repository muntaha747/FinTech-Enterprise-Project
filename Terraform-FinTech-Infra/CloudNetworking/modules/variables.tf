variable "vpc_name" {
  description = "vpc name"
  type        = string
  default     = "FinTech-Infra"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type        = string
}

variable "instance_tenancy" {
  description = "vpc instance tenancy"
  type        = string
  default     = "default"
}

variable "tags" {
  description = "vpc tags"
  type        = map(string)
  default     = {}
}

variable "Environment" {
  description = "vpc environment"
  type        = string
}

variable "Organization" {
  description = "vpc organization"
  type        = string
}

variable "availability_zones" {
  description = "list of availability zones in the region"
  type        = list(string)
}

variable "public_subnet" {
  description = "list of public subnet cidr blocks"
  type        = list(string)
  default     = []
}

variable "private_subnet" {
  description = "list of private subnet cidr blocks"
  type        = list(string)
  default     = []
}

variable "ingress" {
  description = "list of ingress rules for security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress" {
  description = "list of egress rules for security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

