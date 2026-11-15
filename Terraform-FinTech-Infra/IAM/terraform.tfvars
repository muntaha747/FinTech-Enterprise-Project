# terraform.tfvars: the VALUES. One entry per environment, saying which roles it gets.
# The environment names match the infra folders: Dev, QA, Stage, Prod (lower case in role names).

region = "us-east-1"

role_sets = {
  # FinTech-Platform-Admin
  platform = { enable_platform_role = true, enable_product_role = false, enable_cicd_role = false }

  # AppTeam-dev-Role + FinTech-CI-CD-Deployer-dev (full access in dev)
  dev = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }

  # AppTeam-qa-Role + FinTech-CI-CD-Deployer-qa (full access in qa)
  qa = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }

  # AppTeam-stage-Role + FinTech-CI-CD-Deployer-stage (read-only, enforced by the module)
  stage = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }

  # AppTeam-prod-Role + FinTech-CI-CD-Deployer-prod (read-only, enforced by the module)
  prod = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }
}
