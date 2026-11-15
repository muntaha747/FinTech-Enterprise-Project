# main.tf: builds ONE VPC with everything it needs.
# The root module calls this once per VPC (for_each), so 4 VPCs = 4 copies of this file's resources.

locals {
  # Tags added to every resource in this VPC
  common_tags = merge(var.tags, {
    Environment  = var.environment
    Organization = var.organization
  })

  has_public_subnets  = length(var.public_subnet) > 0
  has_private_subnets = length(var.private_subnet) > 0

  # NAT needs a public subnet to live in
  create_nat = var.enable_nat_gateway && local.has_public_subnets
}

################################## VPC ##################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = var.vpc_name })
}

# CHECKOV FIX (CKV2_AWS_12)
# WHAT: took over the VPC's built-in "default" security group and gave it NO rules.
# WHY:  AWS creates this group in every VPC and it allows traffic by default. Anything launched
#       without a security group lands in it, so it must allow nothing (CIS AWS benchmark 5.4).
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.common_tags, { Name = "${var.vpc_name}-default-sg-locked" })
}

################################## VPC Flow Logs ##################################
# CHECKOV FIX (CKV2_AWS_11)
# WHAT: added VPC Flow Logs (4 small resources: log group, IAM role, role policy, flow log).
# WHY:  flow logs record every accepted and rejected connection in the VPC. Without them you
#       cannot investigate an incident or prove network controls to an auditor (PCI-DSS, SOC 2).

# 1. Where the logs are stored
resource "aws_cloudwatch_log_group" "flow_logs" {
  # checkov:skip=CKV_AWS_158: Log group uses CloudWatch's default encryption; a customer KMS key needs its own key policy and is left for a later hardening step
  name              = "/vpc/${var.vpc_name}/flow-logs"
  retention_in_days = var.flow_log_retention_days
  tags              = merge(local.common_tags, { Name = "${var.vpc_name}-flow-logs" })
}

# 2. The role the VPC Flow Logs service uses to write into the log group
resource "aws_iam_role" "flow_logs" {
  name = "${var.vpc_name}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
    }]
  })

  tags = merge(local.common_tags, { Name = "${var.vpc_name}-flow-logs-role" })
}

# 3. What that role may do: write log events into THIS log group only
resource "aws_iam_role_policy" "flow_logs" {
  name = "${var.vpc_name}-flow-logs-policy"
  role = aws_iam_role.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams"]
      Resource = "${aws_cloudwatch_log_group.flow_logs.arn}:*"
    }]
  })
}

# 4. Turn flow logs on for the whole VPC
resource "aws_flow_log" "vpc" {
  vpc_id          = aws_vpc.vpc.id
  traffic_type    = var.flow_log_traffic_type
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  iam_role_arn    = aws_iam_role.flow_logs.arn
  tags            = merge(local.common_tags, { Name = "${var.vpc_name}-flow-log" })
}

################################## Internet Gateway ##################################
# Only created when the VPC has public subnets
resource "aws_internet_gateway" "my_igw" {
  count  = local.has_public_subnets ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.common_tags, { Name = "${var.vpc_name}-igw" })
}

################################## Public subnets ##################################
# count.index % length(...) spreads the subnets across the AZs in turn: 1a, 1b, 1c, 1a, ...
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags              = merge(local.common_tags, { Name = "${var.vpc_name}-public-${count.index + 1}" })
}

################################## Public route table ##################################
resource "aws_route_table" "public_route_table" {
  count  = local.has_public_subnets ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.common_tags, { Name = "${var.vpc_name}-public-rt" })
}

# Attach every public subnet to the public route table
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[0].id
}

# Public route: all internet traffic goes to the Internet Gateway
resource "aws_route" "public_route" {
  count                  = local.has_public_subnets ? 1 : 0
  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = var.internet_cidr_block
  gateway_id             = aws_internet_gateway.my_igw[0].id
}

################################## Public security group ##################################
# for_each over a one-item set = "create it only when public subnets exist"
resource "aws_security_group" "public_subnet_sg" {
  # checkov:skip=CKV2_AWS_5: Not attached inside this module on purpose; other stacks attach it (EKS reads it from the Networking outputs)
  for_each = local.has_public_subnets ? toset(["public"]) : toset([])

  name = "${var.vpc_name}-${each.key}-sg"
  # CHECKOV FIX (CKV_AWS_23)
  # WHAT: added a description to the security group and to every rule (the rule's name from terraform.tfvars).
  # WHY:  a rule without a description cannot be reviewed; nobody knows why the port is open.
  description = "Public tier security group of ${var.vpc_name}"
  vpc_id      = aws_vpc.vpc.id
  tags        = merge(local.common_tags, { Name = "${var.vpc_name}-${each.key}-sg" })

  # One ingress block per rule in var.public_ingress (rule name => settings)
  dynamic "ingress" {
    for_each = var.public_ingress
    content {
      description = "Inbound: ${ingress.key}" # CHECKOV FIX (CKV_AWS_23): rule name as description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.public_egress
    content {
      description = "Outbound: ${egress.key}" # CHECKOV FIX (CKV_AWS_23): rule name as description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

################################## Private subnets ##################################
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  tags              = merge(local.common_tags, { Name = "${var.vpc_name}-private-${count.index + 1}" })
}

################################## Private route table ##################################
resource "aws_route_table" "private_route_table" {
  count  = local.has_private_subnets ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.common_tags, { Name = "${var.vpc_name}-private-rt" })
}

# Attach every private subnet to the private route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[0].id
}

################################## Private security group ##################################
resource "aws_security_group" "private_subnet_sg" {
  # checkov:skip=CKV2_AWS_5: Not attached inside this module on purpose; other stacks attach it (EKS reads it from the Networking outputs)
  for_each = local.has_private_subnets ? toset(["private"]) : toset([])

  name = "${var.vpc_name}-${each.key}-sg"
  # CHECKOV FIX (CKV_AWS_23)
  # WHAT: added a description to the security group and to every rule (the rule's name from terraform.tfvars).
  # WHY:  a rule without a description cannot be reviewed; nobody knows why the port is open.
  description = "Private tier security group of ${var.vpc_name}"
  vpc_id      = aws_vpc.vpc.id
  tags        = merge(local.common_tags, { Name = "${var.vpc_name}-${each.key}-sg" })

  dynamic "ingress" {
    for_each = var.private_ingress
    content {
      description = "Inbound: ${ingress.key}" # CHECKOV FIX (CKV_AWS_23): rule name as description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.private_egress
    content {
      description = "Outbound: ${egress.key}" # CHECKOV FIX (CKV_AWS_23): rule name as description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

################################## NAT Gateway (outbound internet for private subnets) ##################################
# Elastic IP = the fixed public IP the NAT Gateway uses
resource "aws_eip" "nat_eip" {
  count      = local.create_nat ? 1 : 0
  domain     = "vpc"
  tags       = merge(local.common_tags, { Name = "${var.vpc_name}-nat-eip" })
  depends_on = [aws_internet_gateway.my_igw]
}

# The NAT Gateway sits in the first public subnet
resource "aws_nat_gateway" "nat_gateway" {
  count         = local.create_nat ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags          = merge(local.common_tags, { Name = "${var.vpc_name}-nat" })
  depends_on    = [aws_internet_gateway.my_igw]
}

# Private route: internet-bound traffic goes out through the NAT Gateway
resource "aws_route" "nat_gateway_route_table" {
  count                  = local.create_nat && local.has_private_subnets ? 1 : 0
  route_table_id         = aws_route_table.private_route_table[0].id
  destination_cidr_block = var.internet_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat_gateway[0].id
}

################################## VPC endpoints (private access to AWS services) ##################################
# Reads the provider's region, so endpoint service names are never hard-coded
data "aws_region" "current" {}

# S3 gateway endpoint: free, added as a route in the private route table
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_route_table[*].id
  tags              = merge(local.common_tags, { Name = "${var.vpc_name}-s3-endpoint" })
}

# Security group for the interface endpoints: HTTPS from inside this VPC only
resource "aws_security_group" "endpoint_sg" {
  name        = "${var.vpc_name}-endpoint-sg"
  description = "HTTPS from inside ${var.vpc_name} to its interface endpoints" # CHECKOV FIX (CKV_AWS_23): description added so the group's purpose is clear
  vpc_id      = aws_vpc.vpc.id
  tags        = merge(local.common_tags, { Name = "${var.vpc_name}-endpoint-sg" })

  ingress {
    description = "HTTPS from this VPC only" # CHECKOV FIX (CKV_AWS_23): rule description added
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
}

# Interface endpoints: one per service name in var.interface_endpoints (e.g. "ecr.api").
# Each puts a network card in one private subnet per AZ.
resource "aws_vpc_endpoint" "interfaces" {
  for_each            = toset(var.interface_endpoints)
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = slice(aws_subnet.private_subnet[*].id, 0, length(var.availability_zones))
  security_group_ids  = [aws_security_group.endpoint_sg.id]
  private_dns_enabled = true
  tags                = merge(local.common_tags, { Name = "${var.vpc_name}-${each.key}-endpoint" })
}

################################## Transit Gateway (VPC-to-VPC traffic) ##################################
# Plug this VPC into the Transit Gateway, using one private subnet per AZ
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = slice(aws_subnet.private_subnet[*].id, 0, length(var.availability_zones))
  tags               = merge(local.common_tags, { Name = "${var.vpc_name}-tgw-attach" })
}

# Private route: traffic for the other VPCs goes to the Transit Gateway
resource "aws_route" "to_tgw" {
  route_table_id         = aws_route_table.private_route_table[0].id
  destination_cidr_block = var.tgw_destination_cidr_block
  transit_gateway_id     = var.tgw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.tgw_attach]
}
