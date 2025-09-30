locals {
  common_tags = {
    Name = "${var.vpc_name}-${var.env}"
  }
}

# This resource creates the vpc 
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  # vpc logs


  tags = merge(
    local.common_tags,
    {
      Environment                                               = "production"
      Owner                                                     = "devops-team"
      "${format("kubernetes.io/cluster/%s", var.cluster_name)}" = "shared"
    }
  )
}

# This will creates the subnets  public, db  and Private subnets
resource "aws_subnet" "private-subnets" {
  count                   = length(var.private_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets_cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = "app-subnet-${count.index + 1}-${var.env}"
    },
    var.create_for_eks ? {
      "kubernetes.io/role/internal-elb"           = "1"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "karpenter.sh/discovery"                    = var.cluster_name
    } : {}
  )
}

resource "aws_subnet" "db-subnets" {
  count                   = length(var.db_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_subnets_cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = "db-subnet-${count.index + 1}-${var.env}"
    }
  )
}

resource "aws_subnet" "public-subnets" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = "public-subnet-${count.index + 1}-${var.env}"
    },
    var.create_for_eks ? {
      "kubernetes.io/role/elb"                    = "1"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "karpenter.sh/discovery"                    = var.cluster_name
    } : {}
  )
}

# This wil create both internet and Nat gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw-${var.env}"
  }
}

resource "aws_eip" "nat-eip" {
  tags = {
    Name = "${var.vpc_name}-eip-${var.env}"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnets[0].id

  tags = {
    Name        = "${var.vpc_name}-ngw-${var.env}"
    Environment = var.env
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
    Name        = "${var.vpc_name}-public-rt-${var.env}"
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
    Name        = "${var.vpc_name}-private-rt-${var.env}"
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

resource "aws_route_table_association" "db" {
  count          = length(aws_subnet.db-subnets)
  subnet_id      = aws_subnet.db-subnets[count.index].id
  route_table_id = aws_route_table.priv-rt.id
}

resource "aws_security_group" "db_security_group" {
  name        = "${var.vpc_name}-db-sg-${var.env}"
  description = "Database security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]

    description = "Allow PostgreSQL access from VPC CIDR"
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]

    description = "Allow Redis access from VPC CIDR"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

}
