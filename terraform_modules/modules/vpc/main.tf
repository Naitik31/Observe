# -------------------------------------------------------------------
# Data - Get Availability Zones
# -------------------------------------------------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

# -------------------------------------------------------------------
# VPC
# -------------------------------------------------------------------
resource "aws_vpc" "main" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, { Name = "${var.name}-vpc" })
}

# -------------------------------------------------------------------
# Public Subnets
# -------------------------------------------------------------------
resource "aws_subnet" "public" {
  count = var.create_public_subnets && length(var.public_subnet_cidrs) > 0 ? length(var.public_subnet_cidrs) : 0
  vpc_id     = aws_vpc.main[0].id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = (
    length(var.public_availability_zones) > 0
      ? var.public_availability_zones[count.index % length(var.public_availability_zones)]
      : data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  )
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.name}-public-sub-${count.index + 1}"
  })
  depends_on = [aws_vpc.main]
}

# -------------------------------------------------------------------
# Private Subnets
# -------------------------------------------------------------------
resource "aws_subnet" "private" {
  count = var.create_private_subnets && length(var.private_subnet_cidrs) > 0 ? length(var.private_subnet_cidrs) : 0
  vpc_id     = aws_vpc.main[0].id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = (
    length(var.private_availability_zones) > 0
      ? var.private_availability_zones[count.index % length(var.private_availability_zones)]
      : data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  )
  map_public_ip_on_launch = false
  tags = merge(var.tags, {
    Name = "${var.name}-private-sub-${count.index + 1}"
  })
  depends_on = [aws_vpc.main]
}

# -------------------------------------------------------------------
# Internet Gateway
# -------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  tags = merge(var.tags, { Name = "${var.name}-igw" })
  depends_on = [aws_vpc.main]
}

# -------------------------------------------------------------------
# Elastic IP for NAT Gateway
# -------------------------------------------------------------------
resource "aws_eip" "nat_eip" {
  count = var.create_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = merge(var.tags, { Name = "${var.name}-nat-eip" })
  depends_on = [aws_internet_gateway.igw]
}

# -------------------------------------------------------------------
# NAT Gateway (in first Public Subnet)
# -------------------------------------------------------------------
resource "aws_nat_gateway" "ngw" {
  count = var.create_nat_gateway && length(aws_subnet.public) > 0 ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(var.tags, { Name = "${var.name}-nat-gw" })
  depends_on = [aws_internet_gateway.igw, aws_eip.nat_eip, aws_subnet.public]
}

# -------------------------------------------------------------------
# Public Route Table
# -------------------------------------------------------------------
resource "aws_route_table" "public_rt" {
  count  = var.create_internet_gateway && length(aws_subnet.public) > 0 ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
  depends_on = [aws_internet_gateway.igw]
}

# -------------------------------------------------------------------
# Associate Public Subnets
# -------------------------------------------------------------------
resource "aws_route_table_association" "public_assoc" {
  count = var.create_internet_gateway && length(aws_subnet.public) > 0 ? length(aws_subnet.public) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt[0].id
  depends_on = [aws_route_table.public_rt, aws_subnet.public]
}

# -------------------------------------------------------------------
# Private Route Table
# -------------------------------------------------------------------
resource "aws_route_table" "private_rt" {
  count  = var.create_nat_gateway && length(aws_subnet.private) > 0 ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[0].id
  }
  tags = merge(var.tags, { Name = "${var.name}-private-rt" })
  depends_on = [aws_nat_gateway.ngw]
}

# -------------------------------------------------------------------
# Associate Private Subnets
# -------------------------------------------------------------------
resource "aws_route_table_association" "private_assoc" {
  count = var.create_nat_gateway && length(aws_subnet.private) > 0 ? length(aws_subnet.private) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[0].id
  depends_on = [aws_route_table.private_rt, aws_subnet.private]
}