env                  = "prod"
vpc_name             = "barlion"
cluster_name         = "barilon"
azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_cidr             = "10.0.0.0/16"
private_subnets_cidr = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
public_subnets_cidr  = ["10.0.13.0/24", "10.0.14.0/24", "10.0.15.0/24"]
create_for_eks       = true
eks_version          = "1.33"
admin_arn            = "arn:aws:iam::427613144745:user/isreal"
principal_arn        = "arn:aws:iam::427613144745:role/github-oidc"
principal_arn_name   = "admin"
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