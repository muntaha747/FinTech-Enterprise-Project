terraform {
  backend "s3" {
    bucket       = "fintech-project-statefile-bucket"
    key          = "basics/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}