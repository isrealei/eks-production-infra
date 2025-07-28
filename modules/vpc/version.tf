terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"

    }
  }
}
