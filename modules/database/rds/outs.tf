output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.rds.db_instance_arn
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.rds.db_instance_address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.rds.db_instance_resource_id
}

output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = module.rds.db_instance_identifier
}

output "db_instance_name" {
  description = "The database name"
  value       = module.rds.db_instance_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.rds.db_instance_username
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = module.rds.db_instance_port
}
