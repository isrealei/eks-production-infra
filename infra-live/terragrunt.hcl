generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "ravenli-bar"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "barilon"
  }
}
EOF
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    provider "aws" {
        region = "us-east-1"
    }
EOF
}

