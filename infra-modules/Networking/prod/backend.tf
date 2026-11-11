terraform {
  backend "s3" {
    bucket       = "fintech-project-statefile-bucket"
    key          = "product-networking/envs/prod/networking.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
