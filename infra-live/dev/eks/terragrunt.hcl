terraform {
  source = "../../../modules/eks"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  cluster_name = "barilon"
  cluster_version = "1.33"
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnet_ids
  principal_arn = "arn:aws:iam::871983391852:user/admin"
  principal_arn_name = "admin"
  eks_version = "1.33"
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
