# terraform.tfvars: the VALUES for the Prod networking stack.
# CIDR plan for Prod: Edge 10.10.0.0/16 | App 10.20.0.0/16 | Database 10.30.0.0/16 | Ops 10.40.0.0/16
# (every environment uses its own ranges, so no two VPCs in the account overlap)

region             = "us-east-1"
project_name       = "FinTech-Enterprise-Project"
stack_name         = "cloud-networking"
environment        = "Prod"
organization       = "FinTech"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
tgw_name           = "FinTech-TGW"

vpc_setup = {

  #################### EDGE: internet-facing entry tier ####################
  "FinTech-Edge" = {
    cidr                = "10.10.0.0/16"
    public_subnet       = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
    private_subnet      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
    enable_nat_gateway  = false
    interface_endpoints = []

    public_ingress = {
      https = { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    }
    public_egress = {
      all = { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
    }
    private_ingress = {
      https = { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["10.0.0.0/8"] }
    }
    private_egress = {
      all = { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["10.0.0.0/8"] }
    }
  }

  #################### APP: EKS workloads ####################
  "FinTech-App" = {
    cidr          = "10.20.0.0/16"
    public_subnet = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
    private_subnet = [
      "10.20.11.0/24", "10.20.12.0/24", "10.20.13.0/24",
      "10.20.21.0/24", "10.20.22.0/24", "10.20.23.0/24",
    ]
    enable_nat_gateway  = true
    interface_endpoints = ["ecr.api", "ecr.dkr", "secretsmanager", "kms"]

    public_ingress = {
      http  = { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
      https = { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    }
    public_egress = {
      all = { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
    }
    private_ingress = {
      https = { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["10.0.0.0/8"] }
      efs   = { from_port = 2049, to_port = 2049, protocol = "tcp", cidr_blocks = ["10.20.0.0/16"] }
      vault = { from_port = 8200, to_port = 8200, protocol = "tcp", cidr_blocks = ["10.0.0.0/8"] }
    }
    private_egress = {
      all = { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
    }
  }

  #################### DATABASE: data tier, no internet path at all ####################
  "FinTech-Database" = {
    cidr          = "10.30.0.0/16"
    public_subnet = []
    private_subnet = [
      "10.30.11.0/24", "10.30.12.0/24", "10.30.13.0/24",
      "10.30.21.0/24", "10.30.22.0/24", "10.30.23.0/24",
    ]
    enable_nat_gateway  = false
    interface_endpoints = ["kms"]

    private_ingress = {
      postgres   = { from_port = 5432, to_port = 5432, protocol = "tcp", cidr_blocks = ["10.20.0.0/16"] }
      kafka      = { from_port = 9092, to_port = 9092, protocol = "tcp", cidr_blocks = ["10.20.0.0/16"] }
      opensearch = { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["10.20.0.0/16", "10.40.0.0/16"] }
    }
    private_egress = {
      all = { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["10.0.0.0/8"] }
    }
  }

  #################### OPS: monitoring, GitOps and Vault ####################
  "FinTech-Ops" = {
    cidr                = "10.40.0.0/16"
    public_subnet       = ["10.40.1.0/24", "10.40.2.0/24", "10.40.3.0/24"]
    private_subnet      = ["10.40.11.0/24", "10.40.12.0/24", "10.40.13.0/24"]
    enable_nat_gateway  = true
    interface_endpoints = []

    public_egress = {
      all = { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
    }
    private_ingress = {
      https = { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["10.0.0.0/8"] }
      vault = { from_port = 8200, to_port = 8200, protocol = "tcp", cidr_blocks = ["10.0.0.0/8"] }
    }
    private_egress = {
      all = { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
    }
  }
}
