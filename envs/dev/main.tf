terraform {
  backend "s3" {
    region         = "ap-southeast-1"
    bucket         = "nestjs-monolith-terraform"
    key            = "development/terraform.state"
    dynamodb_table = "terraform-state-lockfile-dev"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.24"
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
  region             = "ap-southeast-1"
  env                = "development"
  name               = "nestjs-monolith"
  cidr               = "180.0.0.0/16"
  enable_api_gateway = false
}

// S3
module "s3" {
  depends_on = []
  source     = "../../modules/storage/s3"

  for_each = {
    secret-bucket = {
      name            = "nestjs-secret-bucket"
      type            = "private"
      enabled_version = false
    }
  }

  env             = local.env
  name            = each.value.name
  type            = each.value.type
  enabled_version = each.value.enabled_version
}

module "cloudfront" {
  depends_on = [module.s3]
  source     = "../../modules/network/cloudfront"

  for_each = module.s3
  env      = local.env
  name     = local.name
  region   = local.region

  s3_bucket_id            = each.value.bucket_id
  s3_bucket_arn           = each.value.bucket_arn
  s3_regional_domain_name = each.value.bucket_bucket_domain_name
  price_class             = "PriceClass_100"
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

  ingress_cidr_blocks      = [module.vpc.cidr_block]
  ingress_ipv6_cidr_blocks = [module.vpc.ipv6_cidr_block]
  ingress_rules            = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]
  egress_cidr_blocks       = [module.vpc.cidr_block]
  egress_ipv6_cidr_blocks  = [module.vpc.ipv6_cidr_block]
  egress_rules             = ["all-all"]
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
      rule                     = "all-all"
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
  ]
  egress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.security_group_private.security_group_id
    }
  ]
}

module "security_group_elasticache" {
  depends_on = [module.vpc, module.security_group_private]
  source     = "../../modules/network/scg"

  env  = local.env
  name = "${local.name}-scg-el-${local.env}"

  vpc_id = module.vpc.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "redis-tcp"
      source_security_group_id = module.security_group_private.security_group_id
    },
    {
      rule                     = "redis-tcp"
      source_security_group_id = module.security_group_public.security_group_id
    }
  ]
  egress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.security_group_private.security_group_id
    }
  ]
}


// ALB
module "alb" {
  depends_on = [module.vpc, module.security_group_public]
  source     = "../../modules/autoscaling/alb"

  env                = local.env
  name               = local.name
  enable_api_gateway = local.enable_api_gateway

  app_port        = var.app_port
  app_type        = var.app_type
  app_path        = var.app_path
  acm_cert_domain = var.acm_cert_domain

  vpc_id          = module.vpc.id
  vpc_subnets     = module.vpc.public_subnets
  security_groups = [module.security_group_public.security_group_id]
}

// API_GATEWAY
module "api_gateway" {
  depends_on = [module.vpc, module.alb, module.security_group_public]
  source     = "../../modules/autoscaling/api_gateway"

  env                = local.env
  name               = local.name
  enable_api_gateway = local.enable_api_gateway

  acm_cert_domain = var.acm_cert_domain

  alb_arn            = module.alb.arn
  subnet_ids         = module.vpc.public_subnets
  security_group_ids = [module.security_group_public.security_group_id]
}

# RDS
module "rds" {
  depends_on = [module.vpc, module.security_group_database]
  source     = "../../modules/database/rds"

  env  = local.env
  name = local.name

  database_name = "postgres"
  database_type = "db.t4g.micro"

  database_subnets_group_name = module.vpc.database_subnets_group_name
  database_subnets            = module.vpc.database_subnets
  database_security_groups    = [module.security_group_database.security_group_id]
}

module "elasticache" {
  depends_on = [module.vpc, module.security_group_elasticache]
  source     = "../../modules/database/elasticache"

  env  = local.env
  name = local.name

  enable         = var.enable_elasticache
  enable_cluster = var.enable_elasticache_cluster

  node_number_cache       = 1
  replicas_per_node_group = 0

  node_type          = "cache.t4g.micro"
  subnet_group_name  = module.vpc.elasticache_subnets_group_name
  security_group_ids = [module.security_group_elasticache.security_group_id]
}