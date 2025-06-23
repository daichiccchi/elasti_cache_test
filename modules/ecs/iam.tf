# ECSタスク実行ロール
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project}-ecs-task-execution-role-${var.environment}"
  description = "${var.project} ECS task execution IAM role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project}-ecs-task-execution-role-${var.environment}"
  }
}

# ECSタスク実行ロールにAWSマネージドポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecs_task_execution_managed" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECSタスク実行ロール用のカスタムポリシー
resource "aws_iam_role_policy" "ecs_task_execution_custom" {
  name = "${var.project}-ecs-task-execution-policy-${var.environment}"
  role = aws_iam_role.ecs_task_execution.id

  policy = templatefile("${path.module}/policy/ecs-task-execution-policy.json", {
    log_group_arn = aws_cloudwatch_log_group.ecs.arn
  })
}

# ECSタスクロール
resource "aws_iam_role" "ecs_task" {
  name = "${var.project}-ecs-task-role-${var.environment}"
  description = "${var.project} ECS task IAM role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project}-ecs-task-role-${var.environment}"
  }
}

# ECSタスクロール用のポリシー
resource "aws_iam_role_policy" "ecs_task" {
  name = "${var.project}-ecs-task-policy-${var.environment}"
  role = aws_iam_role.ecs_task.id

  policy = file("${path.module}/policy/ecs-task-policy.json")
}