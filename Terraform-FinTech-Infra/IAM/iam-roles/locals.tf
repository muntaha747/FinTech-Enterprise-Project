# locals.tf: values WORKED OUT from the variables, so main.tf only reads locals.

locals {
  ########## Which roles to create ##########
  create_platform = var.enable_platform_role
  create_product  = var.enable_product_role
  create_cicd     = var.enable_cicd_role

  ########## Who may assume the roles ##########
  # Only this AWS account (its root user / IAM principals)
  account_root_arn = "arn:aws:iam::${var.account_id}:root"

  # GitHub Actions OIDC provider in this account, and the repo allowed to use it
  github_oidc_arn = "arn:aws:iam::${var.account_id}:oidc-provider/${var.github_oidc_host}"
  github_subject  = "repo:${var.github_repo}:*"

  ########## Role 1: platform admin ##########
  platform_name                = var.platform_role_name
  platform_managed_policies    = var.platform_managed_policies
  platform_eks_actions         = var.platform_eks_actions
  platform_kms_actions         = var.platform_kms_actions
  platform_denied_data_actions = var.platform_denied_data_actions

  ########## Role 2: app team ##########
  # Read-only environments (prod, uat) get the restricted list, the rest get full access
  is_read_only     = contains(var.read_only_environments, var.env_type)
  app_team_name    = "${var.app_team_role_prefix}-${var.env_type}-Role" # e.g. AppTeam-qa-Role
  app_team_actions = local.is_read_only ? var.app_team_read_only_actions : var.app_team_full_actions
  app_team_db_arn  = "arn:aws:rds-db:*:*:dbuser:*/${var.env_type}${var.db_user_suffix}" # e.g. qa_user
  app_team_denied  = var.app_team_denied_actions

  ########## Role 3: CI/CD deployer ##########
  cicd_name           = "${var.cicd_role_prefix}-${var.env_type}" # e.g. FinTech-CI-CD-Deployer-qa
  cicd_eks_actions    = local.is_read_only ? var.cicd_eks_read_only_actions : var.cicd_eks_full_actions
  cicd_ecr_actions    = var.cicd_ecr_actions
  cicd_secret_actions = var.cicd_secret_actions
}
