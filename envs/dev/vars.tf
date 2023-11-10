variable "app_path" {
  type        = string
  description = "Container App Prefix Path"
}

variable "app_port" {
  type        = number
  description = "Container App Port"
}

variable "app_type" {
  type        = string
  description = "Container App Type"

  validation {
    condition     = contains(["instance", "ip", "alb"], var.app_type)
    error_message = "Allowed values for input_parameter are \"instance\", \"ip\", or \"alb\"."
  }
}

variable "enable_s3" {
  type        = bool
  description = "Enable AWS S3"
  default     = false
}

variable "enable_cloudfront" {
  type        = bool
  description = "Enable AWS Cloudfront"
  default     = false
}

variable "enable_ecr" {
  type        = bool
  description = "Enable ECR"
  default     = false
}

variable "enable_vpc" {
  type        = bool
  description = "Enable VPC"
  default     = false
}

variable "enable_security_group" {
  type        = bool
  description = "Enable Security Group"
  default     = false
}

variable "enable_load_balancer" {
  type        = bool
  description = "Enable Application Load Balancer"
  default     = false
}

variable "enable_api_gateway" {
  type        = bool
  description = "Enable API Gateway"
  default     = false
}

variable "enable_rds" {
  type        = bool
  description = "Enable RDS"
  default     = false
}

variable "enable_elasticache" {
  type        = bool
  description = "Enable AWS elasticache"
  default     = false
}

variable "enable_elasticache_cluster" {
  type        = bool
  description = "Enable AWS elascache mode Cluster"
  default     = false
}

variable "enable_ecs" {
  type = bool
  description = "Enable ECS"
  default = false
}

variable "acm_cert_domain" {
  type        = string
  description = "acm certification ARNS"
  default     = null
}