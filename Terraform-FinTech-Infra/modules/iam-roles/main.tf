# main.tf: values are written directly here.
# Only the inputs that change per environment come from the root module:
#   var.account_id, var.env_type, var.enable_platform_role, var.enable_product_role, var.enable_cicd_role

############### ROLE 1: PLATFORM ENGINEERING TEAM ###############
module "platform_team_setup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.8.2"

  create = var.enable_platform_role
  name   = "FinTech-Platform-Admin"

  trust_policy_permissions = {
    TrustAccountRoot = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.account_id}:root"]
      }]
    }
  }

  policies = {
    VPC = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
    RDS = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  }

  create_inline_policy = true
  inline_policy_permissions = {
    ManageEKS = {
      effect    = "Allow"
      actions   = ["eks:*"]
      resources = ["*"]
    }
    ManageKMSAndEncryption = {
      effect = "Allow"
      actions = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:PutKeyPolicy",
        "kms:UpdateKeyDescription",
      ]
      resources = ["*"]
    }
    DenyPIIDataAccess = {
      effect    = "Deny"
      actions   = ["s3:GetObject", "dynamodb:GetItem", "rds-db:connect", "kms:Decrypt"]
      resources = ["*"]
    }
  }
}

############### ROLE 2: DEVELOPERS AND QUALITY ENGINEERING TEAM ###############
module "product_team_setup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.8.2"

  create = var.enable_product_role
  name   = "AppTeam-${var.env_type}-Role" # e.g. AppTeam-qa-Role

  trust_policy_permissions = {
    TrustAccountRoot = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.account_id}:root"]
      }]
    }
  }

  create_inline_policy = true
  inline_policy_permissions = {
    # prod and uat get read-only access, qa gets full access
    EKSAndRDSLogic = {
      effect = "Allow"
      actions = (var.env_type == "prod" || var.env_type == "uat") ? [
        "eks:Describe*",
        "eks:List*",
        "eks:AccessKubernetesApi",
        "rds:Describe*",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
      ] : ["eks:*", "rds:*", "ecr:*"]
      resources = ["*"]
    }
    DatabaseConnect = {
      effect    = "Allow"
      actions   = ["rds-db:connect"]
      resources = ["arn:aws:rds-db:*:*:dbuser:*/${var.env_type}_user"] # e.g. qa_user
    }
    FintechGuardrail = {
      effect    = "Deny"
      actions   = ["ec2:DeleteVpc", "ec2:DeleteSubnet", "ec2:DeleteTransitGateway", "ec2:TerminateInstances"]
      resources = ["*"]
    }
  }
}

############### ROLE 3: CI/CD PIPELINE (GITHUB ACTIONS) ###############
module "cicd_pipeline_setup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.8.2"

  create = var.enable_cicd_role
  name   = "FinTech-CI-CD-Deployer-${var.env_type}" # e.g. FinTech-CI-CD-Deployer-qa

  trust_policy_permissions = {
    GitHubActionsOIDC = {
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals = [{
        type        = "Federated"
        identifiers = ["arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"]
      }]
      condition = [{
        test     = "StringLike"
        variable = "token.actions.githubusercontent.com:sub"
        values   = ["repo:muntaha747/FinTech-Enterprise-Project:*"]
      }]
    }
  }

  create_inline_policy = true
  inline_policy_permissions = {
    ContainerRegistryPush = {
      effect = "Allow"
      actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadPart",
        "ecr:CompleteLayerUpload",
      ]
      resources = ["*"]
    }
    # prod and uat: only describe + update config, qa: full EKS access
    UpdateRunningApplication = {
      effect    = "Allow"
      actions   = (var.env_type == "prod" || var.env_type == "uat") ? ["eks:DescribeCluster", "eks:UpdateClusterConfig"] : ["eks:*"]
      resources = ["*"]
    }
    SecretsAccess = {
      effect    = "Allow"
      actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"]
      resources = ["*"]
    }
  }
}
