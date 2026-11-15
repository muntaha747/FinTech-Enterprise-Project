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

variable "oidc_client_id_list" {
  type        = list(string)
  description = "Who is allowed to use the OIDC provider (STS for IRSA)"
}


variable "data_plane_blue" {
  type        = string
  description = "Name of the Core Services Blue node group"
}

variable "data_plane_green" {
  type        = string
  description = "Name of the Core Services Green node group"
}

variable "ml_data_plane_blue" {
  type        = string
  description = "Name of the Machine Learning Blue node group"
}

variable "ml_data_plane_green" {
  type        = string
  description = "Name of the Machine Learning Green node group"
}

variable "node_color" {
  type        = string
  description = "Which node groups to create: blue, green, or both"
  validation {
    condition     = contains(["blue", "green", "both"], var.node_color)
    error_message = "node_color must be blue, green, or both."
  }
}

variable "cluster_autoscaler_chart_version" {
  type        = string
  description = "Version of the cluster-autoscaler Helm chart"
}

variable "cluster_autoscaler_image_tag" {
  type        = string
  description = "Cluster Autoscaler image tag; must match the Kubernetes minor version (e.g. v1.36.x for 1.36)"
}
