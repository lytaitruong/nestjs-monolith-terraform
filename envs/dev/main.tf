terraform {
  backend "s3" {
    region         = "ap-southeast-1"
    bucket         = "nestjs-monolith-terraform"
    key            = "development/terraform.state"
    dynamodb_table = "terraform-state-lockfile-dev"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = local.region
}

locals {
  env    = "development"
  region = "ap-southeast-1"
  name   = "nestjs-monolith"
  cidr   = "180.0.0.0/16"
}

//VPC
module "vpc" {
  source = "../../modules/network/vpc"

  env  = local.env
  name = local.name
  cidr = local.cidr
}