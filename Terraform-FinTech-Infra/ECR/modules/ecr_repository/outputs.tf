# outputs.tf: values this module hands back to the root.

# A for expression builds a map: repository name => repository URL
output "repository_url" {
  description = "Repository name => repository URL"
  value       = { for name, repo in aws_ecr_repository.repo : name => repo.repository_url }
}
