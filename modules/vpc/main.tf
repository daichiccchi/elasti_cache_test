# IPv6を有効にしたVPC
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name = "${var.project}-vpc-${var.environment}"
  }
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw-${var.environment}"
  }
}

# IPv6専用のEgress-onlyインターネットゲートウェイ
resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-eigw-${var.environment}"
  }
}

# ALB用のパブリックサブネット
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.public_subnet_cidrs[count.index]
  availability_zone               = var.availability_zones[count.index]
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)

  tags = {
    Name = "${var.project}-public-subnet-${replace(var.availability_zones[count.index], "ap-northeast-", "")}-${var.environment}"
  }
}

# Fargate用のプライベートサブネット
resource "aws_subnet" "private_fargate" {
  count = length(var.availability_zones)

  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.private_subnet_fargate_cidrs[count.index]
  availability_zone               = var.availability_zones[count.index]
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + 10)

  tags = {
    Name = "${var.project}-private-fargate-subnet-${replace(var.availability_zones[count.index], "ap-northeast-", "")}-${var.environment}"
  }
}

# Aurora用のプライベートサブネット
resource "aws_subnet" "private_db" {
  count = length(var.availability_zones)

  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.private_subnet_db_cidrs[count.index]
  availability_zone               = var.availability_zones[count.index]
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + 20)

  tags = {
    Name = "${var.project}-private-db-subnet-${replace(var.availability_zones[count.index], "ap-northeast-", "")}-${var.environment}"
  }
}

# パブリックサブネット用のルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-public-rt-${var.environment}"
  }
}

# プライベートサブネット用のルートテーブル（Fargate）
resource "aws_route_table" "private_fargate" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-private-fargate-rt-${var.environment}"
  }
}

# プライベートサブネット用のルートテーブル（DB）
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-private-db-rt-${var.environment}"
  }
}

# パブリックルートテーブル用のルート
resource "aws_route" "public_ipv4" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "public_ipv6" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.main.id
}

# プライベートルートテーブル用のルート（Fargate） - IPv6アウトバウンドのみ
resource "aws_route" "private_fargate_ipv6" {
  route_table_id              = aws_route_table.private_fargate.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.main.id
}

# パブリックサブネットとルートテーブルの関連付け
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# プライベートサブネット（Fargate）とルートテーブルの関連付け
resource "aws_route_table_association" "private_fargate" {
  count = length(aws_subnet.private_fargate)

  subnet_id      = aws_subnet.private_fargate[count.index].id
  route_table_id = aws_route_table.private_fargate.id
}

# プライベートサブネット（DB）とルートテーブルの関連付け
resource "aws_route_table_association" "private_db" {
  count = length(aws_subnet.private_db)

  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db.id
}

# Aurora用のDBサブネットグループ
resource "aws_db_subnet_group" "aurora" {
  name       = "${var.project}-aurora-subnet-group-${var.environment}"
  subnet_ids = aws_subnet.private_db[*].id

  tags = {
    Name = "${var.project}-aurora-subnet-group-${var.environment}"
  }
}