resource "aws_ecr_repository" "repo" {
  for_each             = var.ecr_repository
  name                 = each.value
  image_tag_mutability = var.image_mutability

  image_scanning_configuration {
    scan_on_push = true
  }
}
