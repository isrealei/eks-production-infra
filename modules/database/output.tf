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
  value       = aws_db_instance.default.endpoint
}

output "arn" {
  description = "value of the arn"
  value       = aws_db_instance.default.arn
}

output "redis_host" {
  description = "value of the redis host"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}