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

variable "public_subnet_ids" {
  description = "ALBを配置するパブリックサブネットのID"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM証明書のARN（オプション）"
  type        = string
  default     = ""
}

variable "enable_ipv6" {
  description = "IPv6を有効にするか"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "アイドルタイムアウト（秒）"
  type        = number
  default     = 60
}

variable "enable_deletion_protection" {
  description = "削除保護を有効にするか"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "HTTP/2を有効にするか"
  type        = bool
  default     = true
}

variable "tags" {
  description = "リソースに追加するタグ"
  type        = map(string)
  default     = {}
}