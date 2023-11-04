variable "env" {
  type        = string
  description = "Environment"
}

variable "name" {
  type        = string
  description = "Name of VPC"
}

variable "cidr" {
  type        = string
  description = "CIDR Block"

  validation {
    condition     = can(cidrhost(var.cidr, 16))
    error_message = "Must be valid IPv4 CIDR from 10.0.0.0/16 to 255.255.255.255/16"
  }
}
