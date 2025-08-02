variable "env" {
  type        = string
  description = "value for environment"
}

variable "vpc_name" {
  type        = string
  description = "value for vpc name"
}

variable "cluster_name" {
  type        = string
  description = "value for cluster name"
}

variable "azs" {
  type        = list(string)
  description = "values for availability zones"
}

variable "vpc_cidr" {
  type        = string
  description = "value"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "values for private subnets cidr"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "values for public subnets cidr"
}

variable "create_for_eks" {
  type    = bool
  default = true
}

variable "repo_url" {
  type        = string
  description = "URL of the git repository for ArgoCD"
  default     = "https://github.com/isrealei/e-voting-applcation"

}

variable "repo_project" {
  type        = string
  description = "Project name in the git repository for ArgoCD"
  default     = "default"

}


# variable "vpc_config" {

#  description = "vpc configuration for EKS Cluste"
#  type = object ({

#  })

# }


