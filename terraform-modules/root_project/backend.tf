terraform {
  backend "s3" {
    bucket       = "fintech-project-statefile-bucket"
    key          = "modules/root_project/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}