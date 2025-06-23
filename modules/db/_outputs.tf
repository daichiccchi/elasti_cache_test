# Aurora Serverless v2クラスターのエンドポイント
output "aurora_cluster_endpoint" {
  description = "Aurora Serverless v2クラスターのエンドポイント"
  value       = aws_rds_cluster.aurora.endpoint
}

# Aurora Serverless v2クラスターの読み取り専用エンドポイント
output "aurora_cluster_reader_endpoint" {
  description = "Aurora Serverless v2クラスターの読み取り専用エンドポイント"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

# Aurora Serverless v2クラスターID
output "aurora_cluster_id" {
  description = "Aurora Serverless v2クラスターID"
  value       = aws_rds_cluster.aurora.id
}

# Aurora Serverless v2クラスターのポート
output "aurora_cluster_port" {
  description = "Aurora Serverless v2クラスターのポート"
  value       = aws_rds_cluster.aurora.port
}

# Aurora Serverless v2クラスターのセキュリティグループID
output "aurora_security_group_id" {
  description = "Aurora Serverless v2クラスターのセキュリティグループID"
  value       = aws_security_group.aurora.id
}