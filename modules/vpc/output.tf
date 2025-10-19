output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = aws_subnet.private-subnets.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public-subnets.*.id
}

output "db_subnet_ids" {
  value       = aws_subnet.db-subnets.*.id
  description = "The IDs of the database subnets"
}

output "db_security_group_id" {
  value       = aws_security_group.db_security_group.id
  description = "The ID of the database security group"
} 