# 基本設定
variable "project" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名 (dev, stg, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Auroraクラスター用のサブネットID"
  type        = list(string)
}

variable "subnet_group_name" {
  description = "Auroraクラスター用のDBサブネットグループ名"
  type        = string
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