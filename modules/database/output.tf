output "address" {
  description = "The address of the database instance"
  value       = aws_db_instance.default.address
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.default.name
}

output "db_instance_id" {
  description = "The ID of the DB instance"
  value       = aws_db_instance.default.id
}


output "db_instance_endpoint" {
  description = "The endpoint of the DB instance"
  value       = aws_db_instance.default.address
}

output "arn" {
  description = "value of the arn"
  value       = aws_db_instance.default.arn
}

output "redis_host" {
  description = "value of the redis host"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "db_password" {
  description = "value of the database password"
  value       = var.db_password
  sensitive   = true
}