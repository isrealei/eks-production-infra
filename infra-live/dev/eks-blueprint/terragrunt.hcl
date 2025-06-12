terraform {
   source = "git::https://github.com/aws-ia/terraform-aws-eks-blueprints-addons.git"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "eks" {
  config_path = "../eks"
}

inputs = {

  cluster_name      = dependency.eks.outputs.cluster_name
  cluster_endpoint  = dependency.eks.outputs.cluster_endpoint
  cluster_version   = dependency.eks.outputs.cluster_version
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn

  enable_aws_load_balancer_controller    = true
  enable_metrics_server                  = true
  enable_cluster_autoscaler              = true

  kubeconfig_path = "~/.kube/config"


}
