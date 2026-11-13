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
  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw[0].id
}

###############################Public Security for the Ec2s in the Public Subnets########################################
resource "aws_security_group" "public_sg" {
  count  = length(var.public_subnet) > 0 ? 1 : 0
  name   = "${var.vpc_name}-public-sg"
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name         = "${var.vpc_name}-public-sg"
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
  cidr_block        = element(var.private_subnet.*, count.index)
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

