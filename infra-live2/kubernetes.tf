###############################################################################
# Argocd secret for repository
# This secret is used to connect ArgoCD to the git repository where the application manifests are
###############################################################################
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

###############################################################################
# Application manifests for the e-voting application
# This will create a secret which contains the database and redis connection details
###############################################################################
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

###############################################################################
# Karpenter Helm
###############################################################################

data "aws_ecrpublic_authorization_token" "token" {}

resource "helm_release" "karpenter" {
  namespace           = "frontend"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "1.6.0"
  wait                = false
  create_namespace    = true

  values = [
    <<-EOT
    serviceAccount:
       name: ${module.karpenter.service_account}
    settings:
      clusterName: ${module.eks.cluster_name}
      clusterEndpoint: ${module.eks.cluster_endpoint}
      interruptionQueue: ${module.karpenter.queue_name}
    EOT
  ]
}

###############################################################################
# Karpenter Kubectl
###############################################################################

resource "kubectl_manifest" "karpenter" {
  yaml_body = <<-YAML
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
        - key: kubernetes.io/os
          operator: In
          values: ["linux"]
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["on-demand", "spot"]
        - key: karpenter.k8s.aws/instance-category
          operator: In
          values: ["c", "m", "r"]
        - key: karpenter.k8s.aws/instance-generation
          operator: Gt
          values: ["2"]
      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: default
      expireAfter: 720h # 30 * 24h = 720h
  limits:
    cpu: 1000
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 1m
YAML
}

resource "kubectl_manifest" "node_class" {
  yaml_body = <<-YAML
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default
spec:
  role: ${module.karpenter.node_iam_role_arn}
  amiSelectorTerms:
    - alias: "al2023@latest"
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: ${module.eks.cluster_name} 
  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: "${module.eks.cluster_name}"
YAML
}