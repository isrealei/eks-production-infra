terraform {
  source = "../../../modules/vpc"
}

inputs = {
  env                  = "dev"
  vpc-name             = "barlion"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc-cidr             = "10.16.0.0/16"
  private-subnets-cidr = ["10.16.1.0/24", "10.16.2.0/24", "10.16.3.0/24"]
  public-subnets-cidr  = ["10.16.4.0/24", "10.16.5.0/24", "10.16.6.0/24"]
}

include "root" {
  path = find_in_parent_folders()
}
