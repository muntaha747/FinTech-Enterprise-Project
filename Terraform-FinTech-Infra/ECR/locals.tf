# locals.tf: values WORKED OUT from the variables, so main.tf only reads locals.

locals {
  # Tags added to every repository
  common_tags = {
    Project = var.project_name
    Stack   = var.stack_name
  }

  repository_names = var.repository_names
  image_mutability = var.image_mutability
}
