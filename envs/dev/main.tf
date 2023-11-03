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

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "development"
    }
  }
}

locals {
  region = "ap-southeast-1"
  env    = "development"
  name   = "nestjs-monolith"
  cidr   = "180.0.0.0/16"
}

// ECR
module "ecr" {
  depends_on = []
  source     = "../../modules/container/ecr"

  env  = local.env
  name = local.name
}

// VPC
module "vpc" {
  depends_on = []
  source     = "../../modules/network/vpc"

  env  = local.env
  name = local.name
  cidr = local.cidr
}

// SECUIRTY GROUP
module "security_group_public" {
  depends_on = [module.vpc]
  source     = "../../modules/network/scg"

  env  = local.env
  name = "${local.name}-scg-pu-${local.env}"

  vpc_id = module.vpc.id

  ingress_cidr_blocks = [local.cidr]
  ingress_rules       = ["ssh-tcp"]
  ingress_with_self = [
    {
      from_port   = 3333
      to_port     = 3333
      protocol    = "tcp"
      description = "App Service Port"
    }
  ]
  egress_cidr_blocks = [local.cidr]
  egress_rules       = ["all-all"]
}

module "security_group_private" {
  depends_on = [module.vpc, module.security_group_public]
  source     = "../../modules/network/scg"

  env  = local.env
  name = "${local.name}-scg-pr-${local.env}"

  vpc_id = module.vpc.id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3333
      to_port                  = 3333
      protocol                 = "tcp"
      description              = "App Port"
      source_security_group_id = module.security_group_public.security_group_id
    }
  ]
  egress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      description              = "App Port"
      source_security_group_id = module.security_group_public.security_group_id
    }
  ]
}


module "security_group_database" {
  depends_on = [module.vpc, module.security_group_private]
  source     = "../../modules/network/scg"

  env  = local.env
  name = "${local.name}-scg-db-${local.env}"

  vpc_id = module.vpc.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.security_group_private.security_group_id
    },
    {
      rule                     = "redis-tcp"
      source_security_group_id = module.security_group_private.security_group_id
    }
  ]
  egress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      description              = "Outbound database"
      source_security_group_id = module.security_group_private.security_group_id
    }
  ]
}
