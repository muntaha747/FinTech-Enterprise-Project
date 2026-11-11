locals {
  environment = "prod"
  org         = "Wezvatech"

 
  vpcs = {
    edge = {
      cidr                = "10.0.0.0/16"
      public_subnets      = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
      private_subnets     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
      enable_nat_gateway  = true
      gateway_endpoints   = ["s3"]
      interface_endpoints = []
    }
    app = {
      cidr                = "10.1.0.0/16"
      public_subnets      = []
      private_subnets     = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]
      enable_nat_gateway  = false
      gateway_endpoints   = ["s3"]
      interface_endpoints = ["ecr.api", "ecr.dkr", "logs", "secretsmanager"]
    }
    data = {
      cidr                = "10.2.0.0/16"
      public_subnets      = []
      private_subnets     = ["10.2.10.0/24", "10.2.11.0/24", "10.2.12.0/24"]
      enable_nat_gateway  = false
      gateway_endpoints   = ["s3", "dynamodb"]
      interface_endpoints = ["secretsmanager", "kms"]
    }
    ops = {
      cidr                = "10.3.0.0/16"
      public_subnets      = []
      private_subnets     = ["10.3.10.0/24", "10.3.11.0/24", "10.3.12.0/24"]
      enable_nat_gateway  = false
      gateway_endpoints   = ["s3"]
      interface_endpoints = ["ssm", "ssmmessages", "ec2messages"]
    }
  }
}
