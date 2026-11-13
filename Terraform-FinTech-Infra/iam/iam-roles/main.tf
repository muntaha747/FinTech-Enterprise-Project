# main.tf: WHAT to build. Every value comes from locals.tf.
# The upstream module's source and version must be written as fixed text in Terraform.

############### ROLE 1: PLATFORM ENGINEERING TEAM ###############
module "platform_team_setup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.8.2"

  create = local.create_platform
  name   = local.platform_name

  trust_policy_permissions = {
    TrustAccountRoot = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "AWS"
        identifiers = [local.account_root_arn]
      }]
    }
  }

  policies = local.platform_managed_policies

  create_inline_policy = true
  inline_policy_permissions = {
    ManageEKS = {
      effect    = "Allow"
      actions   = local.platform_eks_actions
      resources = ["*"]
    }
    ManageKMSAndEncryption = {
      effect    = "Allow"
      actions   = local.platform_kms_actions
      resources = ["*"]
    }
    DenyPIIDataAccess = {
      effect    = "Deny"
      actions   = local.platform_denied_data_actions
      resources = ["*"]
    }
  }
}

############### ROLE 2: DEVELOPERS AND QUALITY ENGINEERING TEAM ###############
module "product_team_setup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.8.2"

  create = local.create_product
  name   = local.app_team_name

  trust_policy_permissions = {
    TrustAccountRoot = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "AWS"
        identifiers = [local.account_root_arn]
      }]
    }
  }

  create_inline_policy = true
  inline_policy_permissions = {
    EKSAndRDSLogic = {
      effect    = "Allow"
      actions   = local.app_team_actions
      resources = ["*"]
    }
    DatabaseConnect = {
      effect    = "Allow"
      actions   = ["rds-db:connect"]
      resources = [local.app_team_db_arn]
    }
    FintechGuardrail = {
      effect    = "Deny"
      actions   = local.app_team_denied
      resources = ["*"]
    }
  }
}

############### ROLE 3: CI/CD PIPELINE (GITHUB ACTIONS) ###############
module "cicd_pipeline_setup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.8.2"

  create = local.create_cicd
  name   = local.cicd_name

  trust_policy_permissions = {
    GitHubActionsOIDC = {
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals = [{
        type        = "Federated"
        identifiers = [local.github_oidc_arn]
      }]
      condition = [{
        test     = "StringLike"
        variable = "${var.github_oidc_host}:sub"
        values   = [local.github_subject]
      }]
    }
  }

  create_inline_policy = true
  inline_policy_permissions = {
    ContainerRegistryPush = {
      effect    = "Allow"
      actions   = local.cicd_ecr_actions
      resources = ["*"]
    }
    UpdateRunningApplication = {
      effect    = "Allow"
      actions   = local.cicd_eks_actions
      resources = ["*"]
    }
    SecretsAccess = {
      effect    = "Allow"
      actions   = local.cicd_secret_actions
      resources = ["*"]
    }
  }
}
