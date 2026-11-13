resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name         = var.vpc_name
    Environment  = var.Environment
    Organization = var.Organization
  })
}
##################################Internet Gateway########################################
resource "aws_internet_gateway" "my_igw" {
  count  = length(var.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name         = "${var.vpc_name}-igw"
    Environment  = var.Environment
    Organization = var.Organization
  })
}
##################################Public Subnet Creation########################################
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)] # Or you can simply use element(var.availability_zones, count.index)

  tags = merge(var.tags, {
    Name         = "${var.vpc_name}-public-${count.index + 1}"
    Environment  = var.Environment
    Organization = var.Organization
  })
}
###############################Public route table creation########################################
resource "aws_route_table" "public_route_table" {
  count  = length(var.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name         = "${var.vpc_name}-public-rt"
    Environment  = var.Environment
    Organization = var.Organization
  })
}
###############################Public route table association with the public subnets########################################
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnet)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table[0].id
}
###############################Adding Route to the Public Route table########################################
resource "aws_route" "public_route" {
  count                  = length(var.public_subnet) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw[0].id
}
###############################Public Security for the Ec2s in the Public Subnets########################################
resource "aws_security_group" "public_subnet_sg" {
  for_each = length(var.public_subnet) > 0 ? toset(["public"]) : toset([])

  name   = "${var.vpc_name}-${each.key}-sg"
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name         = "${var.vpc_name}-${each.key}-sg"
    Environment  = var.Environment
    Organization = var.Organization
  })

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}
###############################Private Subnets######################################## 
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet, count.index)
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)] # Or you can simply use element(var.availability_zones, count.index)
  tags = merge(var.tags, {
    Name         = "${var.vpc_name}-private-${count.index + 1}"
    Environment  = var.Environment
    Organization = var.Organization
  })
}
###############################Private Route Table######################################## 
resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name         = "${var.vpc_name}-private-rt"
    Environment  = var.Environment
    Organization = var.Organization
  })
}
####################################Associate the RouteTable to Private Subnets################################### 
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnet)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table[0].id
}
####################################Associate the RouteTable to Private Subnets################################### 
resource "aws_security_group" "private_subnet_sg" {
  for_each = length(var.private_subnet) > 0 ? toset(["private"]) : toset([])
  vpc_id   = aws_vpc.vpc.id
  dynamic "ingress" {
    for_each = var.private_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.private_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}
####################################EIP (ELastic IP) for Nat################################### 
resource "aws_eip" "nat_eip" {
  count      = var.enable_nat_gateway && length(var.public_subnet) > 0 ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my_igw]
}
######################################NAT Gateway#######################################
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.enable_nat_gateway && length(var.public_subnet) > 0 ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.my_igw]
}
#######################################MAP ROUTE FOR NAT GATEWAY#################################
resource "aws_route" "Nat_Gateway_Route_table" {
  count                  = var.enable_nat_gateway && length(var.public_subnet) > 0 && length(var.private_subnet) > 0 ? 1 : 0
  route_table_id         = aws_route_table.private_route_table[0].id
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat_gateway[0].id
}

####################################### VPC Endpoint ######################################
data "aws_region" "current" {}

####################################### SG for Interface Endpoints ######################################
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_route_table[*].id
}
#################### SG for Interface Endpoints ####################
resource "aws_security_group" "endpoint_sg" {
  name   = "endpoint-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
}

resource "aws_vpc_endpoint" "interfaces" {
  for_each            = toset(var.interface_endpoints)
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = slice(aws_subnet.private_subnet[*].id, 0, length(var.availability_zones)) # all private subnets
  security_group_ids  = [aws_security_group.endpoint_sg.id]
  private_dns_enabled = true
}

#################### TGW Attachment ####################
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = slice(aws_subnet.private_subnet[*].id, 0, length(var.availability_zones))
  tags               = { Name = "${var.vpc_name}-tgw-attach" }
}

#################### Route: private → TGW ####################
resource "aws_route" "to_tgw" {
  route_table_id         = aws_route_table.private_route_table[0].id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = var.tgw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attach]
}
