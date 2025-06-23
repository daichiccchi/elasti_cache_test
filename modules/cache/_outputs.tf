# ElastiCacheクラスターのエンドポイント
output "elasticache_cluster_address" {
  description = "ElastiCacheクラスターのエンドポイント"
  value       = aws_elasticache_cluster.memcached.cluster_address
}

# ElastiCacheクラスターのポート
output "elasticache_cluster_port" {
  description = "ElastiCacheクラスターのポート"
  value       = aws_elasticache_cluster.memcached.port
}

# ElastiCacheクラスターID
output "elasticache_cluster_id" {
  description = "ElastiCacheクラスターID"  
  value       = aws_elasticache_cluster.memcached.id
}

# ElastiCacheセキュリティグループID
output "elasticache_security_group_id" {
  description = "ElastiCacheセキュリティグループID"
  value       = aws_security_group.elasticache.id
}