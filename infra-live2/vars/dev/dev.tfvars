env               = "prod"
vpc-name          = "barlion"
cluster_name      = "barilon"

azs = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

vpc-cidr = "10.0.0.0/16"

private-subnets-cidr = [
  "10.0.10.0/24",
  "10.0.11.0/24",
  "10.0.12.0/24"
]

public-subnets-cidr = [
  "10.0.13.0/24",
  "10.0.14.0/24",
  "10.0.15.0/24"
]

create_for_eks = true
