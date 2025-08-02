module "vpc" {
  source = "../modules/vpc"

  env                  = var.env
  vpc_name             = var.vpc_name
  cluster_name         = var.cluster_name
  azs                  = var.azs
  vpc_cidr             = var.vpc_cidr
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  create_for_eks       = true
}

module "eks" {
  source     = "../modules/eks"
  depends_on = [module.vpc]

  cluster_name       = "barilon"
  eks_version        = "1.33"
  admin_arn          = "arn:aws:iam::427613144745:user/isreal"
  subnet_ids         = module.vpc.private_subnet_ids
  principal_arn      = "arn:aws:iam::427613144745:role/github-oidc"
  principal_arn_name = "admin"
  node_groups = {
    node1 = {
      instance_types = ["t2.large"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 6
        max_size     = 14
        min_size     = 6
      }
    }
  }
}


module "eks_blueprints_addons" {
  source     = "aws-ia/eks-blueprints-addons/aws"
  version    = "~> 1.0" #ensure to update this to the latest/desired version
  depends_on = [module.eks]

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn


  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    set = [
      { name  = "vpcId"
        value = module.vpc.vpc_id
      }
    ]
  }

  enable_kube_prometheus_stack = true
  enable_metrics_server        = true
  enable_argocd                = true


  tags = {
    Environment = "dev"
  }
}

