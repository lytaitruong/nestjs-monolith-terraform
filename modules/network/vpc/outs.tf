output "id" {
  value = module.vpc.vpc_id
}

output "arn" {
  value = module.vpc.vpc_arn
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = module.vpc.vpc_ipv6_cidr_block
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "database_subnets_group_name" {
  value = module.vpc.database_subnet_group_name
}

output "elasticache_subnets" {
  value = module.vpc.elasticache_subnets
}

output "elasticache_subnets_group_name" {
  value = module.vpc.elasticache_subnet_group_name
}