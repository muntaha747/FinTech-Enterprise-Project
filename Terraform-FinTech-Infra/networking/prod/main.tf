# main.tf: WHAT to build. All values are written directly here.

############################## 1. One network per VPC ##############################
# The module runs once for each VPC below: edge, app, data, ops.
# Inside the module call, each.key is the VPC name (e.g. "app") and each.value is its settings.
module "network" {
  source = "../../modules/networking"

  for_each = {
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
        "10.20.11.0/24", "10.20.12.0/24", "10.20.13.0/24", # EKS control plane (1a, 1b, 1c)
        "10.20.21.0/24", "10.20.22.0/24", "10.20.23.0/24", # EKS data plane    (1a, 1b, 1c)
      ]
      enable_nat_gateway  = true
      gateway_endpoints   = ["s3"]
      interface_endpoints = ["ecr.api", "ecr.dkr", "logs", "secretsmanager"]
    }
    data = {
      cidr           = "10.30.0.0/16"
      public_subnets = []
      private_subnets = [
        "10.30.11.0/24", "10.30.12.0/24", "10.30.13.0/24", # databases      (1a, 1b, 1c)
        "10.30.21.0/24", "10.30.22.0/24", "10.30.23.0/24", # Kafka & Valkey (1a, 1b, 1c)
      ]
      enable_nat_gateway  = false
      gateway_endpoints   = ["s3", "dynamodb"]
      interface_endpoints = ["kms"]
    }
    ops = {
      cidr                = "10.40.0.0/16"
      public_subnets      = ["10.40.1.0/24", "10.40.2.0/24", "10.40.3.0/24"]
      private_subnets     = ["10.40.11.0/24", "10.40.12.0/24", "10.40.13.0/24"] # monitoring, Vault
      enable_nat_gateway  = false
      gateway_endpoints   = ["s3"]
      interface_endpoints = ["ssm", "ssmmessages", "ec2messages"]
    }
  }

  name        = "fintech-prod-${each.key}" # e.g. fintech-prod-app
  vpc_name    = each.key
  vpc_cidr    = each.value.cidr
  azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]
  Environment = "prod"
  org         = "Wezvatech"

  public_subnets      = each.value.public_subnets
  private_subnets     = each.value.private_subnets
  enable_nat_gateway  = each.value.enable_nat_gateway
  gateway_endpoints   = each.value.gateway_endpoints
  interface_endpoints = each.value.interface_endpoints

  # Public security group: HTTPS in from the internet, everything out
  sg_public_ingress = {
    https = { description = "HTTPS from internet", from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  }
  sg_public_egress = {
    all = { description = "All outbound", from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  }

  # Private security group: only traffic from inside the same VPC
  sg_private_ingress = {
    vpc = { description = "All traffic from within VPC", from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = [each.value.cidr] }
  }
  sg_private_egress = {
    all = { description = "All outbound", from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  }
}

############################## 2. Transit Gateway: connects all VPCs ##############################

# The hub router
resource "aws_ec2_transit_gateway" "main" {
  description = "fintech-prod transit gateway"

  tags = { Name = "fintech-prod-tgw" }
}

# Plug every VPC into the hub (one private subnet per AZ)
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc" {
  for_each = toset(["edge", "app", "data", "ops"])

  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = module.network[each.key].vpc_id
  subnet_ids         = module.network[each.key].private_subnet_ids_per_az

  tags = { Name = "fintech-prod-${each.key}-tgw-attachment" }
}

# Private route tables: traffic for any 10.x VPC goes to the hub
resource "aws_route" "private_to_tgw" {
  for_each = toset(["edge", "app", "data", "ops"])

  route_table_id         = module.network[each.key].private_route_table_id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc]
}

# Public route tables (only edge, app and ops have public subnets): same route
resource "aws_route" "public_to_tgw" {
  for_each = toset(["edge", "app", "ops"])

  route_table_id         = module.network[each.key].public_route_table_id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.vpc]
}
