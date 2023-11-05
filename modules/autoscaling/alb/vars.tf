variable "env" {
  type        = string
  description = "Environment"
}

variable "name" {
  type        = string
  description = "Name of Security Group"
}

variable "enable_api_gateway" {
  type        = bool
  default     = false
  description = "Enable HTTP Gateway transfer request to ALB"
}

variable "app_path" {
  type        = string
  description = "Container App Prefix Path"
}

variable "app_port" {
  type        = number
  description = "Container App Port"
}

variable "acm_cert_domain" {
  type        = string
  default     = null
  description = "Container Domain Cert"
}

variable "app_type" {
  type        = string
  description = "Container App Type"

  validation {
    condition     = contains(["instance", "ip", "alb"], var.app_type)
    error_message = "Allowed values for input_parameter are \"instance\", \"ip\", or \"alb\"."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_subnets" {
  type        = list(string)
  description = "Subnets"
}

variable "security_groups" {
  type        = list(string)
  description = "Security Groups"
}