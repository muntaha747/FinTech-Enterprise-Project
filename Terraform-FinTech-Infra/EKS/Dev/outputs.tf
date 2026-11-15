# outputs.tf: values printed after apply.

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "URL of the Kubernetes API server"
  value       = module.eks_cluster.cluster_endpoint
}

# Needed when you create an IAM role for a pod (IRSA)
output "oidc_provider_arn" {
  description = "ARN of the cluster's OIDC provider"
  value       = module.eks_cluster.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "URL of the cluster's OIDC issuer"
  value       = module.eks_cluster.oidc_provider_url
}
