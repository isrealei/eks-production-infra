module "vpc" {
  source = "../../modules/vpc"

  env                  = "dev"
  vpc-name             = "barlion"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc-cidr             = "10.16.0.0/16"
  private-subnets-cidr = ["10.16.1.0/24", "10.16.2.0/24", "10.16.3.0/24"]
  public-subnets-cidr  = ["10.16.4.0/24", "10.16.5.0/24", "10.16.6.0/24"]
  create_for_eks       = true
}

module "eks" {
  source     = "../../modules/eks"
  depends_on = [module.vpc]

  cluster_name       = "barilon"
  eks_version        = "1.33"
  subnet_ids         = module.vpc.private_subnet_ids
  principal_arn      = "arn:aws:iam::871983391852:user/admin"
  principal_arn_name = "admin"
  node_groups = {
    node1 = {
      instance_types = ["t2.micro"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        max_size     = 6
        min_size     = 2
      }
    }
  }
}



