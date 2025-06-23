output "alb_id" {
  description = "ALBのID"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "ALBのARN"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "ALBのDNS名"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "ALBのホストゾーンID"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "ターゲットグループのARN"
  value       = aws_lb_target_group.http.arn
}

output "target_group_name" {
  description = "ターゲットグループの名前"
  value       = aws_lb_target_group.http.name
}

output "https_listener_arn" {
  description = "HTTPSリスナーのARN"
  value       = var.certificate_arn != "" ? aws_lb_listener.https[0].arn : ""
}

output "http_listener_arn" {
  description = "HTTPリスナーのARN"
  value       = aws_lb_listener.http.arn
}

output "security_group_id" {
  description = "ALBセキュリティグループのID"
  value       = aws_security_group.alb.id
}