output "vpc_id" {
  value = module.vpc.public_subnet_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

# output "private_subnet_ids" {
#   value = module.vpc.private_subnet_ids
# }