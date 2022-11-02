terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# AWS provider documentation
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
module "network" {
  source = "./network"
}

