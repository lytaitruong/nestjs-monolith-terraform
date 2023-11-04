data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

/**
  ** Document Link: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  ** Problems Link: https://github.com/terraform-aws-modules/terraform-aws-vpc/issues
*/
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1.2"
  // Conditions create new environment or not if exist
  create_vpc = true

  azs = local.azs

  name = "${var.name}-vpc-${var.env}"
  cidr = var.cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_vpn_gateway     = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = true

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true
  create_database_nat_gateway_route      = true

  // IPv4
  public_subnets   = [for k, v in local.azs : cidrsubnet(var.cidr, 8, 100 + k)]
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 8, 110 + k)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 8, 120 + k)]

  // IPv6
  enable_ipv6 = true

  public_subnet_ipv6_prefixes   = [for k, v in local.azs : k + (length(local.azs) * 0) + 1]
  private_subnet_ipv6_prefixes  = [for k, v in local.azs : k + (length(local.azs) * 1) + 1]
  database_subnet_ipv6_prefixes = [for k, v in local.azs : k + (length(local.azs) * 2) + 1]

  // Defined name
  public_subnet_names   = [for k, v in local.azs : "${var.name}-public-subnet-${v}-${var.env}"]
  private_subnet_names  = [for k, v in local.azs : "${var.name}-private-subnet-${v}-${var.env}"]
  database_subnet_names = [for k, v in local.azs : "${var.name}-database-subnet-${v}-${var.env}"]

  database_subnet_group_name = "${var.name}-dsg-${var.env}"
  database_route_table_tags  = { Name = "${var.name}-rtb-database-${var.env}" }
  private_route_table_tags   = { Name = "${var.name}-rtb-private-${var.env}" }
  public_route_table_tags    = { Name = "${var.name}-rtb-public-${var.env}" }
  vpn_gateway_tags           = { Name = "${var.name}-vpn-${var.env}" }
  nat_eip_tags               = { Name = "${var.name}-eip-${var.env}" }
  igw_tags                   = { Name = "${var.name}-igw-${var.env}" }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}