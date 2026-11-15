# backend.tf: where the state file is stored
terraform {
  backend "s3" {
    bucket       = "fintech-project-statefile-bucket"
    key          = "ecr/envs/ecr.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
