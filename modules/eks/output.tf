output "cluster_endpoint" {
  description = "This is the eks cluster endpoint"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_name" {
  description = "This is the eks cluster name"
  value       = aws_eks_cluster.cluster.name
}

output "cluster_version" {
  description = "This is the eks cluster version"
  value = var.eks_version
}

output "oidc_issuer" {
  description = "This is the eks cluster oidc issuer"
  value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  description = "This is the eks cluster oidc provider arn"
  value = aws_iam_openid_connect_provider.this.arn
}

output "cluster_ca_certificate" {
  description = "This is the eks cluster ca certificate"
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster" {
  description = "This is the eks cluster"
  value = aws_eks_cluster.cluster
}