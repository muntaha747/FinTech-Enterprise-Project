module "ecr_repo" {
  source = "./modules/"
  ecr_repository = [
    "fintech-ledgerservice",
    "fintech-payment",
    "fintech-bff",
    "fintech-notifications",
  ]
  image_mutability = var.image_mutability
}