resource "kubernetes_secret" "argo-repo" {
  metadata {
    name      = "argo-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    url     = var.repo_url
    project = var.repo_project
    type    = "git"
  }
}


# installing karpenter
resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter/karpenter"
  chart            = "karpenter"
  version          = "1.6.0"
  namespace        = "karpenter"
  create_namespace = true

  values = [
    yamldecode({
      settings = {
        clusterName       = var.cluster_name
        interruptionQueue = var.cluster_name
      }
      contoller = {
        resources = {
          limits = {
            cpu    = "1"
            memory = "1Gi"
          }
          requests = {
            cpu    = "1"
            memory = "1Gi"
          }
        }
      }
    })
  ]
  wait = true

  depends_on = [aws_eks_cluster.cluster]

}