# variables.tf: every value main.tf uses. Defaults are the standard settings;
# the root module only passes a value when it wants something different.

########## Naming and tags ##########
variable "name" {
  description = "Name prefix for every resource, e.g. fintech-prod-app"
  type        = string
}

variable "vpc_name" {
  description = "Short VPC role: edge, app, data or ops"
  type        = string
}

variable "Environment" {
  description = "Environment tag value, e.g. prod"
  type        = string
}

variable "org" {
  description = "Organisation tag value"
  type        = string
}

variable "tags" {
  description = "Extra tags added to every resource"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Value of the project tag on the Internet Gateway"
  type        = string
  default     = "WEZVATECH-IGW"
}

variable "public_subnet_tags" {
  description = "Value of the project tag on public subnets"
  type        = string
  default     = "public"
}

variable "private_subnet_tags" {
  description = "Value of the project tag on private subnets"
  type        = string
  default     = "private"
}

########## VPC ##########
variable "vpc_cidr" {
  description = "CIDR block of the VPC, e.g. 10.20.0.0/16"
  type        = string
}

variable "enable_dns_support" {
  description = "Let the VPC resolve DNS (needed for private DNS on endpoints)"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Give instances DNS hostnames (needed for private DNS on endpoints)"
  type        = bool
  default     = true
}

########## Subnets ##########
variable "azs" {
  description = "Availability Zones the subnets are spread across (round-robin)"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDRs of the public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "CIDRs of the private subnets"
  type        = list(string)
  default     = []
}

########## Routing ##########
variable "internet_cidr" {
  description = "Destination for the public route to the Internet Gateway"
  type        = string
  default     = "0.0.0.0/0"
}

variable "route_create_timeout" {
  description = "How long Terraform waits when creating a route"
  type        = string
  default     = "5m"
}

########## Security groups ##########
variable "public_sg_description" {
  description = "Description of the public security group"
  type        = string
  default     = "Security group for public subnets"
}

variable "sg_public_ingress" {
  description = "Inbound rules for the public security group"
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "sg_public_egress" {
  description = "Outbound rules for the public security group"
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "private_sg_description" {
  description = "Description of the private security group"
  type        = string
  default     = "Security group for private subnets"
}

variable "sg_private_ingress" {
  description = "Inbound rules for the private security group"
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "sg_private_egress" {
  description = "Outbound rules for the private security group"
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

########## NAT Gateway ##########
variable "enable_nat_gateway" {
  description = "Create a NAT Gateway so private subnets can reach the internet (outbound only)"
  type        = bool
  default     = false
}

variable "nat_gateway_destination_cidr_block" {
  description = "Destination for the private route to the NAT Gateway"
  type        = string
  default     = "0.0.0.0/0"
}

variable "reuse_nat_ips" {
  description = "Use existing Elastic IPs (external_nat_ip_ids) instead of creating one"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "Existing Elastic IP IDs for the NAT Gateway (used when reuse_nat_ips = true)"
  type        = list(string)
  default     = []
}

########## VPC endpoints ##########
variable "gateway_endpoints" {
  description = "Gateway endpoints to create (s3 and/or dynamodb)"
  type        = list(string)
  default     = ["s3"]
}

variable "interface_endpoints" {
  description = "Interface endpoints to create, e.g. ecr.api, ecr.dkr, kms"
  type        = list(string)
  default     = []
}

variable "endpoint_sg_description" {
  description = "Description of the interface endpoint security group"
  type        = string
  default     = "Allow HTTPS from VPC to interface endpoints"
}

variable "endpoint_rule_description" {
  description = "Description of the inbound rule on the endpoint security group"
  type        = string
  default     = "HTTPS from VPC"
}

variable "endpoint_port" {
  description = "Port the interface endpoints accept from inside the VPC"
  type        = number
  default     = 443
}

variable "endpoint_protocol" {
  description = "Protocol the interface endpoints accept"
  type        = string
  default     = "tcp"
}

variable "endpoint_private_dns_enabled" {
  description = "Resolve normal AWS service names to the endpoint's private IPs"
  type        = bool
  default     = true
}
