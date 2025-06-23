output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.main.ipv6_cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_fargate_subnet_ids" {
  description = "List of IDs of private subnets for Fargate"
  value       = aws_subnet.private_fargate[*].id
}

output "private_db_subnet_ids" {
  description = "List of IDs of private subnets for Aurora"
  value       = aws_subnet.private_db[*].id
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.aurora.name
}

output "db_subnet_group_id" {
  description = "ID of the DB subnet group"
  value       = aws_db_subnet_group.aurora.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "egress_only_internet_gateway_id" {
  description = "The ID of the Egress-only Internet Gateway"
  value       = aws_egress_only_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_fargate_route_table_id" {
  description = "The ID of the private route table for Fargate"
  value       = aws_route_table.private_fargate.id
}

output "private_db_route_table_id" {
  description = "The ID of the private route table for database"
  value       = aws_route_table.private_db.id
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = var.availability_zones
}