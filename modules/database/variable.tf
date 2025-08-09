variable "env" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}
variable "db_subnet_ids" {
  description = "List of DB subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the database will be created"
  type        = string
}


variable "db_name" {
  description = "value of the database name"
  type        = string
}

variable "db_engine" {
  description = "value of the database engine"
  type        = string
}

variable "db_engine_version" {
  description = "value of the database engine version"
  type        = string
}

variable "db_instance_class" {
  description = "value of the database instance class"
  type        = string
}
variable "db_username" {
  description = "value of the database username"
  type        = string
}
variable "db_password" {
  description = "value of the database password"
  type        = string
  sensitive   = true
}