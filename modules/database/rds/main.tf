data "aws_secretsmanager_secret_version" "database" {
  secret_id = "dev/${var.name}/postgres"
}

locals {
  database_info = jsondecode(data.aws_secretsmanager_secret_version.database.secret_string)
}

/**
  ** Document Link: https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
  ** Problems Link: https://github.com/terraform-aws-modules/terraform-aws-rds/issues
*/
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0.0"
  // Conditions create new environment or not if exist
  create_db_instance     = var.enable
  create_db_option_group = true
  create_db_subnet_group = false
  create_monitoring_role = false

  multi_az                            = var.env == "pro" ? true : false
  iam_database_authentication_enabled = false

  network_type         = "DUAL"
  identifier           = "${var.name}-rds-${var.env}"
  family               = "postgres15"
  engine               = "postgres"
  engine_version       = "15.2"
  instance_class       = var.database_type
  major_engine_version = "15"

  db_name  = var.database_name
  username = local.database_info.username
  password = local.database_info.password
  port     = 5432


  storage_type          = var.storage_type
  allocated_storage     = var.storage_size
  max_allocated_storage = var.max_storage_size

  subnet_ids             = var.database_subnets
  db_subnet_group_name   = var.database_subnets_group_name
  vpc_security_group_ids = var.database_security_groups

  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true

  maintenance_window              = "Mon:00:00-Mon:03:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = var.env == "pro" ? true : false

  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  skip_final_snapshot = true
  deletion_protection = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  parameter_group_name = "${var.name}-rds-${var.env}"
  publicly_accessible  = false

  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}