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
  depends_on = [kubernetes_namespace.evoting]
}


resource "null_resource" "wait_for_repo" {
  depends_on = [kubernetes_secret.argo-repo]

  provisioner "local-exec" {
    command = <<EOT
      for i in {1..30}; do
        STATUS=$(kubectl -n argocd get secret argo-repo -o jsonpath='{.metadata.creationTimestamp}')
        if [ ! -z "$STATUS" ]; then
          echo "Repo secret found, waiting for ArgoCD to sync..."
          sleep 5
          exit 0
        fi
        echo "Waiting for ArgoCD repo secret..."
        sleep 5
      done
      echo "Timeout waiting for ArgoCD repo" && exit 1
    EOT
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

  depends_on = [null_resource.wait_for_repo]
}

# resource "kubernetes_namespace" "evoting" {
#   metadata {
#     name = var.namespace
#   }
# }