# outputs.tf: values this module hands back to the root.

############################ Cluster ############################
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks_control_plane.name
}

# The root uses these two to connect the Helm provider to the cluster
output "cluster_endpoint" {
  description = "URL of the Kubernetes API server"
  value       = aws_eks_cluster.eks_control_plane.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Cluster CA certificate (base64), used to trust the API server"
  value       = aws_eks_cluster.eks_control_plane.certificate_authority[0].data
}

############################ OIDC (IRSA) ############################
# Needed when you create an IAM role for a pod (IRSA)
output "oidc_provider_arn" {
  description = "ARN of the cluster's OIDC provider"
  value       = aws_iam_openid_connect_provider.eks_oidc.arn
}

output "oidc_provider_url" {
  description = "URL of the cluster's OIDC issuer"
  value       = aws_iam_openid_connect_provider.eks_oidc.url
}
