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

variable "db_subnets_cidr" {
  type        = list(string)
  description = "values for database subnets cidr"

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


variable "eks_version" {
  description = "value for eks version"
  type        = string
}

variable "admin_arn" {
  type        = string
  description = "ARN of the admin user to administer the EKS cluster"
}

variable "principal_arn" {
  type        = string
  description = "ARN of the principal to be used for EKS access, this will be used by the pipline to access the cluster"
}

variable "principal_arn_name" {
  type        = string
  description = "Name of the principal ARN, used for identification in the EKS module"
  default     = "admin"

}

variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
  description = "Map of node groups with their configurations"
  default     = {}
}


variable "database_config" {
  description = "Database configuration for the application"
  sensitive   = true
  type = object({
    db_name           = string
    db_username       = string
    db_password       = string
    db_instance_class = string
    db_engine         = string
    db_engine_version = string
    project_name      = string
  })
}
variable "namespace" {
  description = "Namespace for the application"
  type        = string
  default     = "default"

}
