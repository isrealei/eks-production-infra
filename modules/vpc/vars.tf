variable "env" {
  description = "Deployment Enviroment"
  type        = string
}

variable "vpc-name" {
  description = "the vpc name"
  type        = string
}

variable "azs" {
  description = "This is the list of azs"
  type        = list(string)
}

variable "vpc-cidr" {
  description = "This is the vpc cidr"
  type        = string
}

variable "private-subnets-cidr" {
  description = "This is the list of private subnets"
  type        = list(string)
}

variable "public-subnets-cidr" {
  description = "This is the list of public subnets"
  type        = list(string)
}

variable "create_for_eks" {
  description = "specify if the cluster is created for eks"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "name of the eks cluster if it is created for eks"
  type        = string
  default     = ""
}