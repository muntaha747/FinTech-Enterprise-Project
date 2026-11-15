# variables.tf: every value this module uses.
# Values without a default MUST be passed by the root module (they differ per environment).
# Values with a default are the standard settings; a root only passes them to change them.

############################ General ############################
variable "region" {
  description = "AWS region of the cluster"
  type        = string
}

variable "environment" {
  description = "Environment tag value: Prod, Stage, QA or Dev"
  type        = string
}

variable "tags" {
  description = "Extra tags added to every resource"
  type        = map(string)
  default     = {}
}

############################ Control plane ############################
variable "cluster_name" {
  description = "Name of the EKS cluster (also the prefix of its IAM roles)"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version, e.g. 1.36"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets (from the Networking stack) for the control plane and the nodes"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Security group (from the Networking stack) attached to the control plane"
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

variable "cluster_log_types" {
  description = "Control plane logs sent to CloudWatch"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_log_retention_days" {
  description = "Days the control plane logs are kept (365 = one year, the usual audit minimum)"
  type        = number
  default     = 365
}

variable "kms_deletion_window_days" {
  description = "Waiting period (7-30 days) before a deleted secrets-encryption key is really removed"
  type        = number
  default     = 7
}

variable "cluster_admin_arns" {
  description = "IAM users/roles that get cluster-admin on EKS (the creator is skipped automatically)"
  type        = list(string)
}

variable "oidc_client_id_list" {
  description = "Who is allowed to use the OIDC provider (STS for IRSA)"
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}

############################ DevOps engineer login ############################
variable "devops_user_name" {
  description = "Name of the DevOps IAM user; its role is named <name>-iam-role (must be unique per environment)"
  type        = string
}

variable "devops_kubernetes_groups" {
  description = "Kubernetes groups the DevOps role is mapped to"
  type        = list(string)
  default     = ["hassan-devops"]
}

############################ Node groups ############################
variable "node_color" {
  description = "Which node groups to create: blue, green, or both"
  type        = string

  validation {
    condition     = contains(["blue", "green", "both"], var.node_color)
    error_message = "node_color must be blue, green, or both."
  }
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

variable "node_instance_types" {
  description = "EC2 instance types of the worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "core_blue_node_count" {
  description = "Minimum (and starting) number of nodes in the Core Blue node group"
  type        = number
  default     = 1
}

variable "standby_node_count" {
  description = "Minimum (and starting) number of nodes in the other three node groups (0 = no cost until needed)"
  type        = number
  default     = 0
}

variable "node_max_size" {
  description = "Most nodes the Cluster Autoscaler may run in one node group"
  type        = number
  default     = 10
}

variable "node_max_unavailable" {
  description = "How many nodes may be replaced at the same time during a node group update"
  type        = number
  default     = 1
}

variable "ml_taint_key" {
  description = "Key of the taint on the ML node groups"
  type        = string
  default     = "dedicated"
}

variable "ml_taint_value" {
  description = "Value of the taint on the ML node groups"
  type        = string
  default     = "ml-inference"
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
