# Needed later when you create an IAM role for a pod (IRSA)
output "oidc_provider_arn" {
  description = "ARN of the cluster's OIDC provider"
  value       = aws_iam_openid_connect_provider.eks_oidc.arn
}

output "oidc_provider_url" {
  description = "URL of the cluster's OIDC issuer"
  value       = aws_iam_openid_connect_provider.eks_oidc.url
}
