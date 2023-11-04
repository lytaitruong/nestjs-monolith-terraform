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
