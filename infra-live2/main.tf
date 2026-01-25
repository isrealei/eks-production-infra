#########################################################################################################
#                                      VPC    PROVISIONING                                               #
#########################################################################################################
module "vpc" {
  source = "../modules/vpc"

  env                  = var.env
  vpc_name             = var.vpc_name
  cluster_name         = var.cluster_name
  azs                  = var.azs
  vpc_cidr             = var.vpc_cidr
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  db_subnets_cidr      = var.db_subnets_cidr
  create_for_eks       = true
}

#########################################################################################################
#                                      EKS  PROVISIONING                                               #
#########################################################################################################
module "eks" {
  source     = "../modules/eks"
  depends_on = [module.vpc]

  cluster_name       = var.cluster_name
  eks_version        = var.eks_version
  admin_arn          = var.admin_arn
  subnet_ids         = module.vpc.private_subnet_ids
  principal_arn      = var.principal_arn
  principal_arn_name = var.principal_arn_name
  node_groups        = var.node_groups
}

#########################################################################################################
#                                      EKS BLUEPRINT FOR INSTALLING CLUSTER ADDONS                      #
#########################################################################################################
module "eks_blueprints_addons" {
  source     = "aws-ia/eks-blueprints-addons/aws"
  version    = "~> 1.0" #ensure to update this to the latest/desired version
  depends_on = [module.eks]

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    # aws-ebs-csi-driver = {
    #   most_recent = true
    # }
  }

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
    Environment = var.env
  }
}

#########################################################################################################
#                                      DATABASE AND CACHE PROVISIONING                                 #
#########################################################################################################
# this  module will create postgress and redis
module "backend" {
  source = "../modules/database"

  vpc_id            = module.vpc.vpc_id
  db_name           = var.database_config.db_name
  db_username       = var.database_config.db_username
  db_password       = var.database_config.db_password
  db_instance_class = var.database_config.db_instance_class
  db_engine         = var.database_config.db_engine
  db_engine_version = var.database_config.db_engine_version
  db_subnet_ids     = module.vpc.db_subnet_ids
  env               = var.env
  project_name      = var.database_config.project_name
  db_security_group = module.vpc.db_security_group_id

  depends_on = [module.vpc]

}


#########################################################################################################
#                                      KARPENTER AWS ROLES AND NODE ROLES INSTALLATION                 #
#########################################################################################################

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "21.0.8"

  cluster_name                    = module.eks.cluster_name
  create_pod_identity_association = true
  namespace                       = "karpenter" # Namespace for Karpenter .

  # Attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}
#########################################################################################################