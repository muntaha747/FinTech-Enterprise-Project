# main.tf: one private ECR repository per name.
# Inside for_each, each.key is the repository name, e.g. "fintech-payment".

resource "aws_ecr_repository" "repo" {
  for_each             = toset(var.repository_names)
  name                 = each.key
  image_tag_mutability = var.image_mutability
  tags                 = var.tags

  # CHECKOV FIX (CKV_AWS_136)
  # WHAT: images are now encrypted with AWS KMS (the AWS-managed ECR key) instead of the basic AES256 key.
  # WHY:  KMS use is permission-checked and logged in CloudTrail, so you can prove who could read the images.
  encryption_configuration {
    encryption_type = var.encryption_type
  }

  # Scan every pushed image for known vulnerabilities (CVEs)
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}
