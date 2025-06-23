# Aurora Serverless v2用のセキュリティグループ
resource "aws_security_group" "aurora" {
  name        = "${var.project}-aurora-sg-${var.environment}"
  description = "${var.project} Aurora Serverless v2 security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-aurora-sg-${var.environment}"
  }
}

# Fargate（ECS）からのPostgreSQL接続を許可（IPv4）
resource "aws_security_group_rule" "aurora_ingress_postgresql_ipv4" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.aurora.id
  description       = "Allow PostgreSQL traffic from VPC (IPv4)"
}

# Aurora Serverless v2クラスター
resource "aws_rds_cluster" "aurora" {
  cluster_identifier     = "${var.project}-aurora-cluster-${var.environment}"
  engine                 = "aurora-postgresql"
  engine_mode           = "provisioned"
  engine_version        = "15.4"
  database_name         = var.database_name
  master_username       = var.master_username
  manage_master_user_password = true
  
  db_subnet_group_name   = var.subnet_group_name
  vpc_security_group_ids = [aws_security_group.aurora.id]
  
  backup_retention_period = 7
  preferred_backup_window = "03:00-04:00"
  preferred_maintenance_window = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  serverlessv2_scaling_configuration {
    min_capacity = var.aurora_min_acu
    max_capacity = var.aurora_max_acu
  }

  tags = {
    Name = "${var.project}-aurora-cluster-${var.environment}"
  }
}

# Aurora Serverless v2インスタンス
resource "aws_rds_cluster_instance" "aurora" {
  identifier         = "${var.project}-aurora-instance-${var.environment}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version

  tags = {
    Name = "${var.project}-aurora-instance-${var.environment}"
  }
}

# 必要なデータソース
data "aws_vpc" "selected" {
  id = var.vpc_id
}