# ElastiCache用のセキュリティグループ
resource "aws_security_group" "elasticache" {
  name        = "${var.project}-elasticache-sg-${var.environment}"
  description = "${var.project} ElastiCache security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-elasticache-sg-${var.environment}"
  }
}

# Fargate（ECS）からのMemcached接続を許可（IPv4）
resource "aws_security_group_rule" "elasticache_ingress_memcached_ipv4" {
  type              = "ingress"
  from_port         = var.cache_port
  to_port           = var.cache_port
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.elasticache.id
  description       = "Allow Memcached traffic from VPC (IPv4)"
}

# ElastiCache用のサブネットグループ
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project}-cache-subnet-group-${var.environment}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project}-cache-subnet-group-${var.environment}"
  }
}

# ElastiCacheクラスター（Memcached）
resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "${var.project}-cache-${var.environment}"
  engine               = "memcached"
  engine_version       = "1.6.12"
  node_type            = var.cache_node_type
  num_cache_nodes      = var.cache_num_nodes
  parameter_group_name = "default.memcached1.6"
  port                 = var.cache_port
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.elasticache.id]

  tags = {
    Name = "${var.project}-cache-${var.environment}"
  }
}

# 必要なデータソース
data "aws_vpc" "selected" {
  id = var.vpc_id
}