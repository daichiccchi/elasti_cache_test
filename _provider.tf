provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
  default_tags {
    tags = {
      Project     = "aws-alb-multi-az-ec2-rds-terraform"
      ManagedBy   = "Terraform"
    }
  }
}