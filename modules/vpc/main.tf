locals {
  common_tags = {
    Name = "${var.vpc-name}-${var.env}"
  }
}

# This resource creates the vpc 
resource "aws_vpc" "main" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Environment = "production"
      Owner       = "devops-team"
    }
  )
}

# This will creates the subnets both public and Private subnets
resource "aws_subnet" "private-subnets" {
  count                   = length(var.private-subnets-cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private-subnets-cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = "private-subnet-${count.index + 1}-${var.env}"
    },
    var.create_for_eks ? {
      "kubernetes.io/role/internal-elb"           = "1"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    } : {}
  )
}

resource "aws_subnet" "public-subnets" {
  count                   = length(var.public-subnets-cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public-subnets-cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = "public-subnet-${count.index + 1}-${var.env}"
    },
    var.create_for_eks ? {
      "kubernetes.io/role/elb"                    = "1"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    } : {}
  )
}

# This wil create both internet and Nat gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc-name}-igw-${var.env}"
  }
}

resource "aws_eip" "nat-eip" {
  tags = {
    Name = "${var.vpc-name}-eip-${var.env}"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnets[0].id

  tags = {
    Name = "${var.vpc-name}-ngw-${var.env}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# This block will creates the various routes
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.vpc-name}-public-rt-${var.env}"
    Environment = var.env
  }
}


resource "aws_route_table" "priv-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name        = "${var.vpc-name}-private-rt-${var.env}"
    Environment = var.env
  }
}


# This block will associate the route table with the subnet
resource "aws_route_table_association" "pub" {
  count          = length(aws_subnet.public-subnets)
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "priv" {
  count          = length(aws_subnet.private-subnets)
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.priv-rt.id
}