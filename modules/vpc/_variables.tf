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

variable "vpc_ipv6_cidr" {
  description = "VPCのIPv6 CIDRブロック（自動割当）"
  type        = string
  default     = ""
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

variable "tags" {
  description = "リソースに追加するタグ"
  type        = map(string)
  default     = {}
}