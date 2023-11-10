/**
  ** Document Link: https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
  ** Problems Link: https://github.com/terraform-aws-modules/terraform-aws-security-group/issues
*/
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"
  // Conditions create new environment or not if exist
  create = var.enable
  vpc_id = var.vpc_id

  name            = var.name
  description     = "Security group for var.name"
  use_name_prefix = false

  ingress_cidr_blocks                   = var.ingress_cidr_blocks
  ingress_ipv6_cidr_blocks              = var.ingress_ipv6_cidr_blocks
  ingress_rules                         = var.ingress_rules
  ingress_with_cidr_blocks              = var.ingress_with_cidr_blocks
  ingress_with_ipv6_cidr_blocks         = var.ingress_with_ipv6_cidr_blocks
  ingress_with_self                     = var.ingress_with_self
  ingress_with_source_security_group_id = var.ingress_with_source_security_group_id

  egress_cidr_blocks                   = var.egress_cidr_blocks
  egress_ipv6_cidr_blocks              = var.egress_ipv6_cidr_blocks
  egress_rules                         = var.egress_rules
  egress_with_cidr_blocks              = var.egress_with_cidr_blocks
  egress_with_ipv6_cidr_blocks         = var.egress_with_ipv6_cidr_blocks
  egress_with_self                     = var.egress_with_self
  egress_with_source_security_group_id = var.egress_with_source_security_group_id

  tags = {
    Environment = var.env
    Name        = var.name
    Terraform   = "true"
  }
}
