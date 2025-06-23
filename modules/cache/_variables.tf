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
  description = "ElastiCache用のサブネットID"
  type        = list(string)
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