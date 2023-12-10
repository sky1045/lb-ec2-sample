resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  for_each = {
    for zone, cidr in var.public_subnets : zone => cidr
  }
  vpc_id = aws_vpc.vpc.id

  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "public-${var.name}-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = {
    for zone, cidr in var.private_subnets : zone => cidr
  }
  vpc_id = aws_vpc.vpc.id

  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = "private-${var.name}-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public["ap-northeast-2a"].id

  tags = {
    Name = "${var.name}-nap"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-rt"
  }
}


resource "aws_route_table_association" "public-rta" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private-rta" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
