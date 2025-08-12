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


resource "kubernetes_secret" "app-cm" {
  metadata {
    name      = "app-cm"
    namespace = var.namespace
  }
  data = {
    POSTGRES_DB       = "vote"
    POSTGRES_HOST     = module.backend.db_instance_endpoint
    POSTGRES_PASSWORD = module.backend.db_password
    POSTGRES_USER     = "postgres"
    REDIS_HOST        = module.backend.redis_host
  }

  depends_on = [kubernetes_namespace.evoting]
}

resource "kubernetes_namespace" "evoting" {
  metadata {
    name = var.namespace
  }
}