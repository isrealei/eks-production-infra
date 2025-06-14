output "cluster_endpoint" {
  description = "This is the eks cluster endpoint"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_name" {
  description = "This is the eks cluster name"
  value       = aws_eks_cluster.cluster.name
}

output "cluster_version" {
  value = var.eks_version
}

output "oidc_issuer" {
  value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}
