terraform {
  backend "s3" {
    bucket       = "fintech-project-statefile-bucket"
    key          = "product-name/envs/qa/s3.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

  }
}
