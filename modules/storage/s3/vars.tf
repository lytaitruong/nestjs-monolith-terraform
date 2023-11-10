variable "env" {
  type        = string
  description = "Environment"
}

variable "name" {
  type        = string
  description = "Name of S3"
}

variable "type" {
  type        = string
  description = "Private Or Public"

  validation {
    condition     = contains(["private", "public", "public-read"], var.type)
    error_message = "Allowed values for input_parameter are \"private\", \"public\", \"public-read\"."
  }
}

variable "enabled_version" {
  type        = bool
  description = "Enable Versioning"
}