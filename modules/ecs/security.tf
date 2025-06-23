# ECSサービス用セキュリティグループ
resource "aws_security_group" "ecs_service" {
  name        = "${var.project}-ecs-service-sg-${var.environment}"
  description = "${var.project} ECS service security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-ecs-service-sg-${var.environment}"
  }
}

# ECSサービスからのアウトバウンド通信を許可（IPv4）
resource "aws_security_group_rule" "ecs_service_egress_ipv4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_service.id
  description       = "Allow all IPv4 outbound traffic"
}

# ECSサービスからのアウトバウンド通信を許可（IPv6）
resource "aws_security_group_rule" "ecs_service_egress_ipv6" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ecs_service.id
  description       = "Allow all IPv6 outbound traffic"
}

# VPC内からのHTTP通信を許可
resource "aws_security_group_rule" "ecs_service_ingress_http_from_vpc" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.ecs_service.id
  description       = "Allow HTTP traffic from VPC"
}

# 必要なデータソース
data "aws_vpc" "selected" {
  id = var.vpc_id
}