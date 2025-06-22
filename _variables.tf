variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "environment" {
  type    = string
}
