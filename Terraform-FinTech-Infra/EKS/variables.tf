variable "region" {
  type        = string
  description = "Region variables"
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes Version"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "endpoint_private_access" {
  type        = bool
  description = "Allow access to the EKS API from inside the VPC"
}

variable "endpoint_public_access" {
  type        = bool
  description = "Allow access to the EKS API from the internet"
}
