output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = aws_subnet.private-subnets.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public-subnets.*.id
}

