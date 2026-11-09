# FinTech Enterprise Project: S3 Infrastructure with Terraform automation project

A small project that builds a secure S3 bucket on AWS using Terraform. A GitHub Actions pipeline checks, tests and deploys it automatically.

## What it does

- Creates an S3 compliance bucket using a reusable Terraform module
- Logs in to AWS without stored passwords, using GitHub OIDC
- Checks the code for formatting problems and security issues before deploying
- Stores Terraform state in a remote backend with state locking

## Project structure

```
.
├── .github/workflows/
│   └── ci-infra-s3.yaml          # the pipeline
├── infra-modules/
│   ├── prod/
│   ├── stage/
│   └── qa/s3/
│       ├── backend.tf            # remote state and locking
│       ├── main.tf               # calls the bucket module
│       ├── .terraform.lock.hcl   # locked provider versions
│       └── s3_compliance_bucket/
│           ├── main.tf           # the bucket itself
│           ├── variables.tf      # inputs
│           └── outputs.tf        # outputs
└── terraform-modules/
```

## How the pipeline works

The pipeline runs on every push to `dev` and on pull requests to `main` and `dev`.

| Step | What it does |
|------|--------------|
| Checkout | Downloads the code |
| Configure AWS Credentials | Logs in to AWS using OIDC |
| Terraform Format | Fails if the code is not formatted |
| Terraform Init | Sets up Terraform and the backend |
| Checkov Scan | Scans for security problems (reports only, does not fail the build) |
| Terraform Plan | Shows what will change |
| Terraform Apply | Builds the bucket (only on a push to `dev`) |
| Post-Deployment Test | Placeholder for future tests |
| Terraform Destroy | Removes everything after a push to `dev`, so test resources do not stay running |

## AWS login (OIDC)

The pipeline does not use access keys. GitHub proves who it is, and AWS gives temporary access.

Setup needed in AWS:

1. An OIDC identity provider for `token.actions.githubusercontent.com` with audience `sts.amazonaws.com`
2. An IAM role named `FinTech_Enterprise_Project_GithubActions_OIDC_Role` with a trust policy that only allows this repo
3. The role ARN saved as a GitHub secret

Important: the trust policy must match the exact name GitHub sends, which includes ID numbers:

```
repo:OWNER@OWNER_ID/REPO@REPO_ID:*
```

## Requirements

- Terraform 1.10.0 or newer (needed for state locking with `use_lockfile`)
- An AWS account with permission to create S3 buckets
- A GitHub repo with Actions enabled

## Run it locally

```bash
cd infra-modules/qa/s3
terraform init
terraform plan
terraform apply
```

## Inputs and outputs

Add a table here listing the variables from `variables.tf` and the values from `outputs.tf`.

## Lessons learned

- AWS OIDC errors do not say which part did not match. Printing the real token values in a debug step shows the problem quickly.
- Newer GitHub repos can send ID numbers in the OIDC name, so check it before writing a trust policy.
- Newer runners block `pip install` system-wide, so `pipx` is used for Checkov.

## Author

Muntaha, [muntaha.ca]