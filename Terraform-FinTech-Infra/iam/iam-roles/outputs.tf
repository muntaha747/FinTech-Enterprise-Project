# outputs.tf: values this module hands back to the root (null when a role is not enabled).

output "platform_role_arn" {
  description = "ARN of FinTech-Platform-Admin"
  value       = module.platform_team_setup.arn
}

output "app_team_role_arn" {
  description = "ARN of AppTeam-<env>-Role"
  value       = module.product_team_setup.arn
}

output "cicd_role_arn" {
  description = "ARN of FinTech-CI-CD-Deployer-<env>"
  value       = module.cicd_pipeline_setup.arn
}
