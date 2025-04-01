resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    "Name" = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_a_cidr
  map_public_ip_on_launch = true
  availability_zone = var.availability_zones[0]

  tags = {
    "Name" = "${var.prefix}-public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_b_cidr
  map_public_ip_on_launch = true
  availability_zone = var.availability_zones[1]

  tags = {
    "Name" = "${var.prefix}-public-subnet-b"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_a_cidr
  map_public_ip_on_launch = false
  availability_zone = var.availability_zones[0]

  tags = {
    "Name" = "${var.prefix}-private-subnet-a"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "Name" = "${var.prefix}-igw"
  }
}

resource "aws_eip" "ngw_eip" {
  tags = {
    "Name" = "${var.prefix}-ngw-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id = aws_subnet.public_subnet_a.id

  tags = {
    "Name" = "${var.prefix}-ngw"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_rtb_a" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
}

resource "aws_route_table_association" "public_rtb_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_rtb_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "private_rtb_a" {
  subnet_id = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_rtb_a.id
}