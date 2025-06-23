# VPC outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

# ALB outputs
output "alb_dns_name" {
  description = "ALBのDNS名"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALBのHosted Zone ID"
  value       = module.alb.alb_zone_id
}

# ECS outputs
output "ecs_cluster_id" {
  description = "ECSクラスターID"
  value       = module.ecs.cluster_id
}

output "ecs_service_name" {
  description = "ECSサービス名"
  value       = module.ecs.service_name
}

# Aurora Serverless v2 outputs
output "aurora_cluster_endpoint" {
  description = "Aurora Serverless v2クラスターのエンドポイント"
  value       = module.db.aurora_cluster_endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "Aurora Serverless v2クラスターの読み取り専用エンドポイント"
  value       = module.db.aurora_cluster_reader_endpoint
}

output "aurora_cluster_port" {
  description = "Aurora Serverless v2クラスターのポート"
  value       = module.db.aurora_cluster_port
}

# ElastiCache outputs
output "elasticache_cluster_address" {
  description = "ElastiCacheクラスターのエンドポイント"
  value       = module.cache.elasticache_cluster_address
}

output "elasticache_cluster_port" {
  description = "ElastiCacheクラスターのポート"
  value       = module.cache.elasticache_cluster_port
}