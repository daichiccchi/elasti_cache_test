output "cluster_id" {
  description = "ECSクラスターのID"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "ECSクラスターのARN"
  value       = aws_ecs_cluster.main.arn
}

output "cluster_name" {
  description = "ECSクラスターの名前"
  value       = aws_ecs_cluster.main.name
}

output "service_id" {
  description = "ECSサービスのID"
  value       = aws_ecs_service.app.id
}

output "service_name" {
  description = "ECSサービスの名前"
  value       = aws_ecs_service.app.name
}

output "task_definition_arn" {
  description = "タスク定義のARN"
  value       = aws_ecs_task_definition.app.arn
}

output "task_definition_family" {
  description = "タスク定義のファミリー名"
  value       = aws_ecs_task_definition.app.family
}

output "task_execution_role_arn" {
  description = "タスク実行ロールのARN"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "task_role_arn" {
  description = "タスクロールのARN"
  value       = aws_iam_role.ecs_task.arn
}

output "security_group_id" {
  description = "ECSサービス用セキュリティグループのID"
  value       = aws_security_group.ecs_service.id
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch LogsグループのID"
  value       = aws_cloudwatch_log_group.ecs.name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch LogsグループのARN"
  value       = aws_cloudwatch_log_group.ecs.arn
}