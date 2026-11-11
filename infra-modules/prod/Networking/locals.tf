locals {
  environment = "prod"
  org         = "Wezvatech"

  # Subnets are spread round-robin across these AZs (6 subnets = 2 per AZ)
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Transit Gateway: one route that covers every VPC CIDR below (10.10 ... 10.40)
  tgw_route_cidr = "10.0.0.0/8"

  vpcs = {
    edge = {
      cidr                = "10.10.0.0/16"
      public_subnets      = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
      private_subnets     = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
      enable_nat_gateway  = false
      gateway_endpoints   = ["s3"]
      interface_endpoints = []
    }
    app = {
      cidr           = "10.20.0.0/16"
      public_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
      private_subnets = [
        "10.20.11.0/24", "10.20.12.0/24", "10.20.13.0/24", # Control Plane (1a, 1b, 1c)
        "10.20.21.0/24", "10.20.22.0/24", "10.20.23.0/24", # Data Plane    (1a, 1b, 1c)
      ]
      enable_nat_gateway  = true
      gateway_endpoints   = ["s3"]
      interface_endpoints = ["ecr.api", "ecr.dkr", "logs", "secretsmanager"]
    }
    data = {
      cidr           = "10.30.0.0/16"
      public_subnets = []
      private_subnets = [
        "10.30.11.0/24", "10.30.12.0/24", "10.30.13.0/24", # DBs           (1a, 1b, 1c)
        "10.30.21.0/24", "10.30.22.0/24", "10.30.23.0/24", # Kafka & Redis (1a, 1b, 1c)
      ]
      enable_nat_gateway  = false
      gateway_endpoints   = ["s3", "dynamodb"]
      interface_endpoints = ["kms"]
    }
    ops = {
      cidr                = "10.40.0.0/16"
      public_subnets      = ["10.40.1.0/24", "10.40.2.0/24", "10.40.3.0/24"]    # NAT for external alerts
      private_subnets     = ["10.40.11.0/24", "10.40.12.0/24", "10.40.13.0/24"] # Monitoring/vaults
      enable_nat_gateway  = false
      gateway_endpoints   = ["s3"]
      interface_endpoints = ["ssm", "ssmmessages", "ec2messages"]
    }
  }
}
