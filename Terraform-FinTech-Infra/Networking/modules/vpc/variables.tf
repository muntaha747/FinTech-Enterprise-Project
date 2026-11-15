# variables.tf: every value main.tf uses.
# Defaults are the standard settings; the root module only passes what is different.

################################## VPC ##################################
variable "vpc_name" {
  description = "Name of the VPC (also used as a prefix for everything inside it)"
  type        = string
}

variable "vpc_cidr_block" {
  description = "IP range of the VPC, e.g. 10.20.0.0/16"
  type        = string
}

variable "instance_tenancy" {
  description = "VPC tenancy: default (shared hardware) or dedicated"
  type        = string
  default     = "default"
}

variable "availability_zones" {
  description = "Availability zones to spread the subnets across"
  type        = list(string)
}

################################## Tags ##################################
variable "environment" {
  description = "Environment tag value, e.g. Prod"
  type        = string
}

variable "organization" {
  description = "Organization tag value"
  type        = string
}

variable "tags" {
  description = "Extra tags added to every resource"
  type        = map(string)
  default     = {}
}

################################## Subnets ##################################
variable "public_subnet" {
  description = "CIDR blocks of the public subnets (empty list = no public subnets)"
  type        = list(string)
  default     = []
}

variable "private_subnet" {
  description = "CIDR blocks of the private subnets"
  type        = list(string)
  default     = []
}

################################## Security group rules ##################################
# Every rule set is a map: rule name => settings. The rule name is only a label.
variable "public_ingress" {
  description = "Inbound rules of the public security group (rule name => settings)"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "public_egress" {
  description = "Outbound rules of the public security group (rule name => settings)"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "private_ingress" {
  description = "Inbound rules of the private security group (rule name => settings)"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "private_egress" {
  description = "Outbound rules of the private security group (rule name => settings)"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

################################## Flow logs ##################################
variable "flow_log_traffic_type" {
  description = "Which traffic the VPC Flow Logs record: ALL, ACCEPT or REJECT"
  type        = string
  default     = "ALL"
}

variable "flow_log_retention_days" {
  description = "Days the VPC Flow Logs are kept (365 = one year, the usual audit minimum)"
  type        = number
  default     = 365
}

################################## Internet access ##################################
variable "enable_nat_gateway" {
  description = "Create a NAT Gateway so private subnets can reach the internet (outbound only)"
  type        = bool
  default     = false
}

variable "internet_cidr_block" {
  description = "CIDR that means 'the whole internet' in the route tables"
  type        = string
  default     = "0.0.0.0/0"
}

################################## VPC endpoints ##################################
variable "interface_endpoints" {
  description = "AWS services reached privately through interface endpoints, e.g. [\"ecr.api\", \"kms\"]"
  type        = list(string)
  default     = []
}

################################## Transit Gateway ##################################
variable "tgw_id" {
  description = "ID of the Transit Gateway this VPC attaches to"
  type        = string
}

variable "tgw_destination_cidr_block" {
  description = "Traffic for this range is sent to the Transit Gateway (covers all FinTech VPCs)"
  type        = string
  default     = "10.0.0.0/8"
}
