############################## VPC (Virtual Private Cloud Networks) ##############################
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge({
    Name        = "Fintech-${var.vpc_name}-vpc"
    Environment = var.Environment
    org         = var.org
    }
  )
}

############################## IGW (Internet Gateway) ##############################
resource "aws_internet_gateway" "my_igw" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id
  tags   = merge({ Name = var.name, project = var.igw_tags })
}


############################## Availability Zones ##############################
# Subnets go round-robin across var.azs: with 3 AZs, subnet 0->1a, 1->1b, 2->1c, 3->1a, 4->1b ...
# So the first length(var.azs) private subnets are exactly one per AZ.
locals {
  private_subnet_ids_per_az = slice(
    aws_subnet.private_subnet[*].id, 0, min(length(var.azs), length(var.private_subnets))
  )
}

############################## Public Subnets #######################################
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = var.azs[count.index % length(var.azs)]
  tags = merge({
    Name      = "Fintech-${var.vpc_name}-public-subnet-${count.index}"
    "project" = var.public_subnet_tags
  })
}

############################## Public Route Table #######################################
resource "aws_route_table" "public" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Public RouteTable - WEZVATECH"
  }
}

############################## Public Route Table #######################################
resource "aws_route_table_association" "public_Route_table_association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

############################## Public Route Table Route Entry to the Route Table#######################################
resource "aws_route" "public_internet_gateway" {
  count                  = length(var.public_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw[0].id
  timeouts {
    create = "5m"
  }
}
############################## Public Subnets Security Group #######################################
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

############################## Private Subnet #######################################
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = merge(
    {
      Name      = "fintech-${var.vpc_name}-private-subnet-${count.index}"
      "project" = var.private_subnet_tags
    }
  )
}

############################## Private Route Table #######################################
resource "aws_route_table" "private" {
  count  = length(var.private_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Private RouteTable - WEZVATECH"
  }
}
############################## Private Route Table Subnets associations #######################################

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private[0].id
}

############################## Private Subnets Security Groups #######################################

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
}

############################## NAT GATEWAY IPS #######################################

locals {
  nat_gateway_ips = var.reuse_nat_ips ? var.external_nat_ip_ids : try(aws_eip.nat[*].id, [])
}

# CREATE EIP FOR NAT GATEWAY
resource "aws_eip" "nat" {
  count      = var.enable_nat_gateway && length(var.public_subnets) > 0 ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my_igw]
}

# CREATE NAT GATEWAY
resource "aws_nat_gateway" "public" {
  count         = var.enable_nat_gateway && length(var.public_subnets) > 0 ? 1 : 0
  allocation_id = element(local.nat_gateway_ips, count.index)
  subnet_id     = aws_subnet.public_subnet[0].id

  depends_on = [aws_internet_gateway.my_igw]
}

# MAP ROUTE FOR NAT GATEWAY
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.public[0].id
  timeouts {
    create = "5m"
  }
}

######### VPC Endpoints ################

data "aws_region" "current" {}

########## Gateway endpoints (S3 / DynamoDB) ##########
resource "aws_vpc_endpoint" "gateway" {
  for_each          = toset(var.gateway_endpoints)
  vpc_id            = aws_vpc.my_vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.${each.key}"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = { Name = "${var.name}-${each.key}-endpoint" }
}

########## Security group for interface endpoints ##########
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

########## Interface endpoints ##########
resource "aws_vpc_endpoint" "interface" {
  for_each            = toset(var.interface_endpoints)
  vpc_id              = aws_vpc.my_vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.private_subnet_ids_per_az # endpoints allow only one subnet per AZ
  security_group_ids  = [aws_security_group.endpoint_sg[0].id]
  private_dns_enabled = true

  tags = { Name = "${var.name}-${each.key}-endpoint" }
}
