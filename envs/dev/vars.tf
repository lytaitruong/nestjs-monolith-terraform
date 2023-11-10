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

variable "acm_cert_domain" {
  type        = string
  description = "acm certification ARNS"
  default     = null
}

variable "enable_elasticache" {
  type        = bool
  description = "enable AWS elasticache"
  default     = false
}

variable "enable_elasticache_cluster" {
  type        = bool
  description = "enable AWS elascache mode Cluster"
  default     = false
}
