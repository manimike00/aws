terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.location
}

# helm provider
#provider "helm" {
#  kubernetes {
#    host = module.eks.kube_api_server
#    client_certificate = ""
#    client_key = ""
#    cluster_ca_certificate = ""
#  }
#}