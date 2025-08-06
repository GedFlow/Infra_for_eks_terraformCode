#---------------
# VPC 및 네트워킹
#--------------

resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_base_name}-VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.cluster_base_name}-IGW"
  }
}

# 퍼블릭 서브넷 및 라우팅
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_1_block
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.cluster_base_name}-PublicSubnet1"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_2_block
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.cluster_base_name}-PublicSubnet2"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.cluster_base_name}-PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# 프라이빗 서브넷 및 라우팅
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_1_block
  availability_zone = var.availability_zone_1

  tags = {
    Name                              = "${var.cluster_base_name}-PrivateSubnet1"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_2_block
  availability_zone = var.availability_zone_2

  tags = {
    Name                              = "${var.cluster_base_name}-PrivateSubnet2"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.cluster_base_name}-PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private_1_assoc" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

