# terraform.tfvars: the VALUES. One entry per environment, saying which roles it gets.

region = "us-east-1"

role_sets = {
  # FinTech-Platform-Admin
  platform = { enable_platform_role = true, enable_product_role = false, enable_cicd_role = false }

  # AppTeam-qa-Role + FinTech-CI-CD-Deployer-qa (full access in qa)
  qa = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }

  # AppTeam-uat-Role + FinTech-CI-CD-Deployer-uat (read-only, enforced by the module)
  uat = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }

  # AppTeam-prod-Role + FinTech-CI-CD-Deployer-prod (read-only, enforced by the module)
  prod = { enable_platform_role = false, enable_product_role = true, enable_cicd_role = true }
}
