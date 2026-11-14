# outputs.tf: values printed after apply.

output "platform_role_arn" {
  description = "ARN of FinTech-Platform-Admin (null if not enabled)"
  value       = try(module.iam_roles["platform"].platform_role_arn, null) # null if there is no "platform" entry
}

# A for expression builds a map of environment -> role ARN, for every environment.
output "app_team_role_arns" {
  description = "AppTeam role ARN per environment"
  value       = { for env, role in module.iam_roles : env => role.app_team_role_arn }
}

output "cicd_role_arns" {
  description = "CI/CD deployer role ARN per environment"
  value       = { for env, role in module.iam_roles : env => role.cicd_role_arn }
}
