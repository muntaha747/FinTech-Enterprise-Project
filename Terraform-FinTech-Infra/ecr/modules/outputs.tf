output "repository_url" {
  value       = { for k, v in aws_ecr_repository.repo : k => v.repository_url }
  description = "Map of repository names to their respective ECR URLs"
}
