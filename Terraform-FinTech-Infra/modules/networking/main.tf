# main.tf: values are written directly here.
# Only the inputs that are DIFFERENT for each VPC come from the root module:
#   var.name, var.vpc_name, var.Environment, var.org, var.vpc_cidr, var.azs,
#   var.public_subnets, var.private_subnets, var.enable_nat_gateway,
#   var.gateway_endpoints, var.interface_endpoints, var.sg_* rules
# Example: for the app VPC, var.name = "fintech-prod-app" and var.vpc_cidr = "10.20.0.0/16".

############################## VPC ##############################
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}-vpc"
    Environment = var.Environment
    org         = var.org
    Tier        = var.vpc_name
  }
}

############################## Internet Gateway (only if there are public subnets) ##############################
resource "aws_internet_gateway" "my_igw" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id

  tags = { Name = "${var.name}-igw" }
}

############################## Public subnets ##############################
# Subnets go round-robin across the AZs: subnet 0 → 1a, 1 → 1b, 2 → 1c, 3 → 1a ...
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = { Name = "${var.name}-public-subnet-${count.index}" }
}

resource "aws_route_table" "public" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id

  tags = { Name = "${var.name}-public-rt" }
}

resource "aws_route_table_association" "public_Route_table_association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Public route: all internet traffic → Internet Gateway
resource "aws_route" "public_internet_gateway" {
  count                  = length(var.public_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_security_group" "public" {
  count       = length(var.public_subnets) > 0 ? 1 : 0
  name        = "${var.name}-public-sg"
  description = "Security group for public subnets"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = var.sg_public_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.sg_public_egress
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = { Name = "${var.name}-public-sg" }
}

############################## Private subnets ##############################
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = { Name = "${var.name}-private-subnet-${count.index}" }
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id

  tags = { Name = "${var.name}-private-rt" }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private[0].id
}

resource "aws_security_group" "private" {
  count       = length(var.private_subnets) > 0 ? 1 : 0
  name        = "${var.name}-private-sg"
  description = "Security group for private subnets"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "egress" {
    for_each = var.sg_private_egress
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  dynamic "ingress" {
    for_each = var.sg_private_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  tags = { Name = "${var.name}-private-sg" }
}

############################## NAT Gateway (only if enable_nat_gateway = true) ##############################
resource "aws_eip" "nat" {
  count      = var.enable_nat_gateway && length(var.public_subnets) > 0 ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my_igw]

  tags = { Name = "${var.name}-nat-eip" }
}

resource "aws_nat_gateway" "public" {
  count         = var.enable_nat_gateway && length(var.public_subnets) > 0 ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.my_igw]

  tags = { Name = "${var.name}-nat" }
}

# Private route: all internet traffic → NAT Gateway (outbound only)
resource "aws_route" "private_nat_gateway" {
  count                  = var.enable_nat_gateway && length(var.public_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public[0].id

  timeouts {
    create = "5m"
  }
}

############################## VPC endpoints ##############################
# Gateway endpoints (S3 / DynamoDB): free, added to the private route table
resource "aws_vpc_endpoint" "gateway" {
  for_each          = toset(var.gateway_endpoints)
  vpc_id            = aws_vpc.my_vpc.id
  service_name      = "com.amazonaws.us-east-1.${each.key}" # e.g. com.amazonaws.us-east-1.s3
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = { Name = "${var.name}-${each.key}-endpoint" }
}

# Security group for interface endpoints: HTTPS (443) from inside the VPC only
resource "aws_security_group" "endpoint_sg" {
  count       = length(var.interface_endpoints) > 0 ? 1 : 0
  name        = "${var.name}-endpoint-sg"
  description = "Allow HTTPS from VPC to interface endpoints"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = { Name = "${var.name}-endpoint-sg" }
}

# Interface endpoints (ECR, KMS, ...): a private IP in the first 3 private subnets (one per AZ)
resource "aws_vpc_endpoint" "interface" {
  for_each            = toset(var.interface_endpoints)
  vpc_id              = aws_vpc.my_vpc.id
  service_name        = "com.amazonaws.us-east-1.${each.key}" # e.g. com.amazonaws.us-east-1.ecr.api
  vpc_endpoint_type   = "Interface"
  subnet_ids          = slice(aws_subnet.private_subnet[*].id, 0, 3)
  security_group_ids  = [aws_security_group.endpoint_sg[0].id]
  private_dns_enabled = true

  tags = { Name = "${var.name}-${each.key}-endpoint" }
}
