# main.tf: WHAT to build. Every value comes from locals.tf.

# One private ECR repository per name in terraform.tfvars
module "ecr_repo" {
  source           = "./modules/ecr_repository"
  repository_names = local.repository_names
  image_mutability = local.image_mutability
  tags             = local.common_tags
}
