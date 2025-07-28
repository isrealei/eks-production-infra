module "vpc" {
  source = "../modules/vpc"

  env                  = "dev"
  vpc-name             = "barlion"
  cluster_name         = "barilon"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc-cidr             = "10.16.0.0/16"
  private-subnets-cidr = ["10.16.1.0/24", "10.16.2.0/24", "10.16.3.0/24"]
  public-subnets-cidr  = ["10.16.4.0/24", "10.16.5.0/24", "10.16.6.0/24"]
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

