variable "env" {
  type        = string
  description = "value for environment"
}

variable "vpc-name" {
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

variable "vpc-cidr" {
  type        = string
  description = "value"
}

variable "private-subnets-cidr" {
  type        = list(string)
  description = "values for private subnets cidr"
}

variable "public-subnets-cidr" {
  type        = list(string)
  description = "values for public subnets cidr"
}

variable "create_for_eks" {
  type    = bool
  default = true
}

