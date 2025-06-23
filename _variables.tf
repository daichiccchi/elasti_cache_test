variable "aws_region" {
  description = "リソースをデプロイするAWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "使用するAWSプロファイル"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "環境名（dev/stg/prod）"
  type        = string
}

variable "project" {
  description = "プロジェクト名"
  type        = string
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
}

variable "availability_zones" {
  description = "使用するアベイラビリティゾーンのリスト"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "public_subnet_cidrs" {
  description = "パブリックサブネット（ALB用）のCIDRブロック"
  type        = list(string)
}

variable "private_subnet_fargate_cidrs" {
  description = "プライベートサブネット（Fargate用）のCIDRブロック"
  type        = list(string)
}

variable "private_subnet_db_cidrs" {
  description = "プライベートサブネット（Aurora用）のCIDRブロック"
  type        = list(string)
}

variable "container_image" {
  description = "ECSで使用するコンテナイメージのURI"
  type        = string
  default     = "nginx:latest"
}

variable "task_cpu" {
  description = "ECSタスクのCPU（単位: CPU units）"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "ECSタスクのメモリ（単位: MB）"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "ECSサービスの希望するタスク数"
  type        = number
  default     = 1
}

variable "certificate_arn" {
  description = "ACM証明書のARN（オプション）"
  type        = string
  default     = ""
}

# Aurora Serverless v2設定
variable "aurora_min_acu" {
  description = "Aurora Serverless v2の最小ACU"
  type        = number
  default     = 0
}

variable "aurora_max_acu" {
  description = "Aurora Serverless v2の最大ACU"
  type        = number
  default     = 1
}

variable "database_name" {
  description = "データベース名"
  type        = string
}

variable "master_username" {
  description = "マスターユーザー名"
  type        = string
}

# ElastiCache設定
variable "cache_node_type" {
  description = "ElastiCacheノードタイプ"
  type        = string
  default     = "cache.t4g.small"
}

variable "cache_num_nodes" {
  description = "ElastiCacheノード数"
  type        = number
  default     = 1
}

variable "cache_port" {
  description = "ElastiCacheポート"
  type        = number
  default     = 11211
}

