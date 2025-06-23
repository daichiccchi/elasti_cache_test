# ECSクラスター
resource "aws_ecs_cluster" "main" {
  name = "${var.project}-ecs-cluster-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project}-ecs-cluster-${var.environment}"
  }
}

# ECSクラスター容量プロバイダー
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# CloudWatch Logsグループ
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project}-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.project}-ecs-logs-${var.environment}"
  }
}

# ECSタスク定義
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project}-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "${var.project}-container-${var.environment}"
      image     = var.container_image
      essential = true
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      # HTTPポート
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name = "${var.project}-task-${var.environment}"
  }
}

# ECSサービス
resource "aws_ecs_service" "app" {
  name            = "${var.project}-service-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
    base              = 1
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = false
  }

  # ALBターゲットグループとの連携
  dynamic "load_balancer" {
    for_each = var.target_group_arn != "" ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = "${var.project}-container-${var.environment}"
      container_port   = 80
    }
  }

  # サービスの再起動を防ぐため
  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = {
    Name = "${var.project}-service-${var.environment}"
  }
}