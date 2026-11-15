# outputs.tf: values printed after apply.

output "repository_urls" {
  description = "Repository name => URL to push and pull images"
  value       = module.ecr_repo.repository_url
}
