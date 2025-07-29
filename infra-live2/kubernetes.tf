resource "kubernetes_secret" "argo-repo" {
  metadata {
    name      = "argo-repo"
    namespace = "argocd"
    labels = {
      "argo.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    url     = var.repo_url
    project = var.repo_project
  }
}