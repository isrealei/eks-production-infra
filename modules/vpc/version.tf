terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"

    }
  }
}
