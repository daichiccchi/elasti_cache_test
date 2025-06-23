variable "environment" {
  description = "環境名（dev/stg/prod）"
  type        = string
}

variable "project" {
  description = "プロジェクト名"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "subnet_ids" {
  description = "ECSタスクを配置するサブネットのID"
  type        = list(string)
}

variable "container_image" {
  description = "コンテナイメージのURI"
  type        = string
  default     = "nginx:latest"
}

variable "task_cpu" {
  description = "タスクのCPU（単位: CPU units）"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "タスクのメモリ（単位: MB）"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "希望するタスク数"
  type        = number
  default     = 1
}

variable "aws_region" {
  description = "AWSリージョン"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch Logsの保持期間（日）"
  type        = number
  default     = 7
}

variable "target_group_arn" {
  description = "ALBターゲットグループのARN"
  type        = string
  default     = ""
}


variable "tags" {
  description = "リソースに追加するタグ"
  type        = map(string)
  default     = {}
}