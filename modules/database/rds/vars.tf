variable "env" {
  type        = string
  description = "Environment"
}

variable "name" {
  type        = string
  description = "Name of Identifier"
}

variable "database_name" {
  type        = string
  description = "RDS Database name"
  sensitive   = true
}

variable "database_type" {
  type        = string
  description = "RDS Database Type"
}

variable "database_security_groups" {
  type        = list(string)
  description = "RDS Security Groups"
}

variable "database_subnets" {
  type        = list(string)
  description = "RDS Subnets Groups"
}

variable "database_subnets_group_name" {
  type        = string
  description = "RDS Database Subnet Group Name"
}

variable "storage_type" {
  type        = string
  description = "Database Storage Type"
  default     = "gp2"

  validation {
    condition     = contains(["gp2", "gp3", "io1"], var.storage_type)
    error_message = "Allowed values for input_parameter are \"gp2\", \"gp3\", \"io1\"."
  }
}

variable "storage_size" {
  type        = number
  description = "Database Storage Size - Min 5 GB ~ Max 64000 GB"
  default     = 5

  validation {
    condition     = var.storage_size < 512
    error_message = "If more than 512 GB please edit this validation manually"
  }
}

variable "max_storage_size" {
  type        = string
  description = "Max Database Storage Type"
  default     = 50

  validation {
    condition     = var.max_storage_size < 512
    error_message = "If more than 512 GB please edit this validation manually"
  }
}