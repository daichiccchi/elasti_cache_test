# ALB用セキュリティグループ
resource "aws_security_group" "alb" {
  name        = "${var.project}-alb-sg-${var.environment}"
  description = "${var.project} ALB security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-alb-sg-${var.environment}"
  }
}

# HTTPSトラフィックを許可（IPv4）
resource "aws_security_group_rule" "alb_ingress_https_ipv4" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS traffic from Internet (IPv4)"
}

# HTTPSトラフィックを許可（IPv6）
resource "aws_security_group_rule" "alb_ingress_https_ipv6" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS traffic from Internet (IPv6)"
}

# HTTPトラフィックを許可（リダイレクト用・IPv4）
resource "aws_security_group_rule" "alb_ingress_http_ipv4" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP traffic from Internet (IPv4)"
}

# HTTPトラフィックを許可（リダイレクト用・IPv6）
resource "aws_security_group_rule" "alb_ingress_http_ipv6" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP traffic from Internet (IPv6)"
}

# ALBからVPC内へのアウトバウンド通信を許可（IPv4）
resource "aws_security_group_rule" "alb_egress_vpc_ipv4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound traffic to VPC (IPv4)"
}

# ALBからVPC内へのアウトバウンド通信を許可（IPv6）
resource "aws_security_group_rule" "alb_egress_vpc_ipv6" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = [data.aws_vpc.selected.ipv6_cidr_block]
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound traffic to VPC (IPv6)"
}

# 必要なデータソース
data "aws_vpc" "selected" {
  id = var.vpc_id
}