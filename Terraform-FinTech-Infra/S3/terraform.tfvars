# terraform.tfvars: the VALUES for this stack. Add a bucket by adding a name.
region       = "us-east-1"
project_name = "FinTech-Enterprise-Project"
stack_name   = "s3"
environment  = "production"
bucket_names = [
  "fintech-dvc-data-lake",
  "fintech-applog",
]
