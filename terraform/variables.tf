variable "region" {
  description = "AWS region for the platform"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name used for naming and tagging"
  type        = string
  default     = "fintech-enterprise"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cluster_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.31"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "karpenter_chart_version" {
  description = "Karpenter Helm chart version"
  type        = string
  default     = "1.0.8"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDRs allowed to reach the public EKS API endpoint. Restrict this to your own IP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

locals {
  name = "${var.project}-eks"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
