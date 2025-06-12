variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet ids for the cluster"
  type        = list(string)
}

variable "node_groups" {
  description = "EKS node group"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}

variable "principal_arn" {
  description = "This is the arn that will grant an iam user access to the cluster"
  type        = string
}


variable "principal_arn_name" {
  description = "This is the principal arn name for cluster admin"
  type = string
}

variable "eks_version" {
  description = "This is the value for the eks cluster"
  type = string
}


