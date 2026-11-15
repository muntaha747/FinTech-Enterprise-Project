# providers.tf: which cloud to talk to, and in which region
provider "aws" {
  region = var.region
}
