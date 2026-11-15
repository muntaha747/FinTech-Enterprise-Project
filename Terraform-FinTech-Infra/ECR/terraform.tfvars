# terraform.tfvars: the VALUES for this stack. Add a repository by adding a name.
region       = "us-east-1"
project_name = "FinTech-Enterprise-Project"
stack_name   = "ecr"
repository_names = [
  "fintech-ledgerservice",
  "fintech-payment",
  "fintech-bff",
  "fintech-notifications",
]
# CHECKOV FIX (CKV_AWS_51)
# WHAT: changed MUTABLE -> IMMUTABLE.
# WHY:  an immutable tag can never be overwritten, so the image that was scanned and approved
#       is exactly the image that runs. Pipelines must push a NEW tag each time (e.g. the git SHA),
#       not re-push "latest".
image_mutability = "IMMUTABLE"
