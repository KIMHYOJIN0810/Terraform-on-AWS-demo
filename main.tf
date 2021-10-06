#this is a github actions test
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 0.14"

  backend "remote" {
    organization = "hjkim_demo"

    workspaces {
      name = "Terraform-on-AWS-lsglobal-demo"
    }
  }
}


provider "aws" {
  region = "ap-southeast-1"
}


