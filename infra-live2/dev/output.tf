output "vpc_id" {
  value = module.vpc.public_subnet_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "cluster_endpoint" {
  description = "This is the eks cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "This is the eks cluster name"
  value       = module.eks.cluster_name
}

output "cluster_version" {
  value = module.eks.cluster_version
}

# output "oidc_issuer" {
#   value = module.eks.oidc_issuer
# }

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

