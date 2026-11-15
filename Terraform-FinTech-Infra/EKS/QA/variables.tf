# variables.tf: the INPUTS this stack accepts. Values are set in terraform.tfvars.
# No defaults here on purpose: every value is visible in terraform.tfvars.

############################ General ############################
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

variable "environment" {
  description = "Environment name: Prod, Stage, QA or Dev"
  type        = string
}

############################ Networking lookup ############################
variable "networking_state_bucket" {
  description = "S3 bucket that holds the Networking stack's state file"
  type        = string
}

variable "networking_state_key" {
  description = "Path of this environment's Networking state file inside the bucket"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC (a key of the Networking outputs) the cluster is placed in"
  type        = string
}

############################ Control plane ############################
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "endpoint_private_access" {
  description = "Allow access to the EKS API from inside the VPC"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Allow access to the EKS API from the internet"
  type        = bool
}

variable "cluster_admin_arns" {
  description = "IAM users/roles that get cluster-admin on EKS (the creator is skipped automatically)"
  type        = list(string)
}

variable "devops_user_name" {
  description = "Name of the DevOps IAM user (must be unique per environment)"
  type        = string
}

############################ Node groups ############################
variable "node_color" {
  description = "Which node groups to create: blue, green, or both"
  type        = string
}

variable "data_plane_blue" {
  description = "Name of the Core Services Blue node group"
  type        = string
}

variable "data_plane_green" {
  description = "Name of the Core Services Green node group"
  type        = string
}

variable "ml_data_plane_blue" {
  description = "Name of the Machine Learning Blue node group"
  type        = string
}

variable "ml_data_plane_green" {
  description = "Name of the Machine Learning Green node group"
  type        = string
}

############################ Cluster Autoscaler ############################
variable "cluster_autoscaler_chart_version" {
  description = "Version of the cluster-autoscaler Helm chart"
  type        = string
}

variable "cluster_autoscaler_image_tag" {
  description = "Cluster Autoscaler image tag; must match the Kubernetes minor version (e.g. v1.36.x for 1.36)"
  type        = string
}
