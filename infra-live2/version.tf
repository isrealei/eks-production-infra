terraform {
  backend "s3" {}
  required_providers {
    kubectl = {
      source  = "kahirokunn/kubectl"
      version = "1.13.11"
    }

  }
}


provider "helm" {
  kubernetes {
    # Use the EKS cluster endpoint and CA certificate to configure the Helm provider{
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}


data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}


data "aws_region" "current" {}
