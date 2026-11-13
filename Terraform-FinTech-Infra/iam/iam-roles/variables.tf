# variables.tf: every value main.tf uses. Defaults are the standard settings;
# the root module only passes a value when it wants something different.

########## Who and where ##########
variable "account_id" {
  description = "AWS account ID the roles trust"
  type        = string
}

variable "env_type" {
  description = "Environment the roles are for: platform, qa, uat or prod"
  type        = string
}

variable "read_only_environments" {
  description = "Environments where the app team and CI/CD get restricted (read-only) permissions"
  type        = list(string)
  default     = ["prod", "uat"]
}

########## Which roles to create ##########
variable "enable_platform_role" {
  description = "Create the platform admin role"
  type        = bool
  default     = false
}

variable "enable_product_role" {
  description = "Create the app team role"
  type        = bool
  default     = false
}

variable "enable_cicd_role" {
  description = "Create the CI/CD deployer role"
  type        = bool
  default     = false
}

########## Role 1: platform admin ##########
variable "platform_role_name" {
  description = "Name of the platform admin role"
  type        = string
  default     = "FinTech-Platform-Admin"
}

variable "platform_managed_policies" {
  description = "AWS managed policies attached to the platform admin role"
  type        = map(string)
  default = {
    VPC = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
    RDS = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  }
}

variable "platform_eks_actions" {
  description = "EKS actions the platform admin may run"
  type        = list(string)
  default     = ["eks:*"]
}

variable "platform_kms_actions" {
  description = "KMS actions the platform admin may run"
  type        = list(string)
  default = [
    "kms:Create*",
    "kms:Describe*",
    "kms:Enable*",
    "kms:List*",
    "kms:PutKeyPolicy",
    "kms:UpdateKeyDescription",
  ]
}

variable "platform_denied_data_actions" {
  description = "Actions the platform admin may NEVER run (protects customer PII)"
  type        = list(string)
  default     = ["s3:GetObject", "dynamodb:GetItem", "rds-db:connect", "kms:Decrypt"]
}

########## Role 2: app team ##########
variable "app_team_role_prefix" {
  description = "App team role name becomes <prefix>-<env>-Role"
  type        = string
  default     = "AppTeam"
}

variable "app_team_full_actions" {
  description = "App team actions in non-restricted environments (e.g. qa)"
  type        = list(string)
  default     = ["eks:*", "rds:*", "ecr:*"]
}

variable "app_team_read_only_actions" {
  description = "App team actions in read-only environments (e.g. uat, prod)"
  type        = list(string)
  default = [
    "eks:Describe*",
    "eks:List*",
    "eks:AccessKubernetesApi",
    "rds:Describe*",
    "ecr:BatchGetImage",
    "ecr:GetDownloadUrlForLayer",
  ]
}

variable "db_user_suffix" {
  description = "App team may connect to the database as <env><suffix>, e.g. qa_user"
  type        = string
  default     = "_user"
}

variable "app_team_denied_actions" {
  description = "Actions the app team may NEVER run (guardrail)"
  type        = list(string)
  default     = ["ec2:DeleteVpc", "ec2:DeleteSubnet", "ec2:DeleteTransitGateway", "ec2:TerminateInstances"]
}

########## Role 3: CI/CD deployer (GitHub Actions) ##########
variable "cicd_role_prefix" {
  description = "CI/CD role name becomes <prefix>-<env>"
  type        = string
  default     = "FinTech-CI-CD-Deployer"
}

variable "github_oidc_host" {
  description = "GitHub's OIDC provider host"
  type        = string
  default     = "token.actions.githubusercontent.com"
}

variable "github_repo" {
  description = "Only this GitHub repository (owner/name) may assume the CI/CD role"
  type        = string
  default     = "muntaha747/FinTech-Enterprise-Project"
}

variable "cicd_ecr_actions" {
  description = "ECR actions the pipeline needs to push images"
  type        = list(string)
  default = [
    "ecr:GetAuthorizationToken",
    "ecr:BatchCheckLayerAvailability",
    "ecr:GetDownloadUrlForLayer",
    "ecr:BatchGetImage",
    "ecr:PutImage",
    "ecr:InitiateLayerUpload",
    "ecr:UploadPart",
    "ecr:CompleteLayerUpload",
  ]
}

variable "cicd_eks_full_actions" {
  description = "Pipeline EKS actions in non-restricted environments"
  type        = list(string)
  default     = ["eks:*"]
}

variable "cicd_eks_read_only_actions" {
  description = "Pipeline EKS actions in read-only environments"
  type        = list(string)
  default     = ["eks:DescribeCluster", "eks:UpdateClusterConfig"]
}

variable "cicd_secret_actions" {
  description = "Secret actions the pipeline needs"
  type        = list(string)
  default     = ["secretsmanager:GetSecretValue", "kms:Decrypt"]
}
