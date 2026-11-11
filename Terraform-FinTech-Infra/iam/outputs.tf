# outputs.tf: values printed after apply.

output "platform_role_arn" {
  description = "ARN of FinTech-Platform-Admin"
  value       = module.iam_roles["platform"].platform_role_arn
}

output "app_team_role_arns" {
  description = "AppTeam role ARN per environment"
  value = {
    qa   = module.iam_roles["qa"].app_team_role_arn
    uat  = module.iam_roles["uat"].app_team_role_arn
    prod = module.iam_roles["prod"].app_team_role_arn
  }
}

output "cicd_role_arns" {
  description = "CI/CD deployer role ARN per environment"
  value = {
    qa   = module.iam_roles["qa"].cicd_role_arn
    uat  = module.iam_roles["uat"].cicd_role_arn
    prod = module.iam_roles["prod"].cicd_role_arn
  }
}
