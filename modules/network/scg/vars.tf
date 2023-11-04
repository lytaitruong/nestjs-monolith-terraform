variable "env" {
  type        = string
  description = "Environment"
}

variable "name" {
  type        = string
  description = "Name of Security Group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR Inbound"

  validation {
    condition     = alltrue([for cidr in var.ingress_cidr_blocks : can(cidrhost(cidr, 16))])
    error_message = "Must be valid IPv4 CIDR from 10.0.0.0/16 to 255.255.255.255/16"
  }
}

variable "ingress_ipv6_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR IPv6 Inbound"
}

variable "ingress_rules" {
  type        = list(string)
  default     = []
  description = "List Inbound rules"
}

variable "ingress_with_cidr_blocks" {
  type = list(object({
    rule        = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    protocol    = optional(number)
    description = optional(number)
    cidr_blocks = optional(string)
  }))
  default     = []
  description = "List Inbound rules"
}

variable "ingress_with_ipv6_cidr_blocks" {
  type = list(object({
    rule        = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    protocol    = optional(number)
    description = optional(number)
    cidr_blocks = optional(string)
  }))
  default     = []
  description = "List Inbound rules"
}

variable "ingress_with_self" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
  default     = []
  description = "List Inbound rules"
}

variable "ingress_with_source_security_group_id" {
  type        = list(map(string))
  default     = []
  description = "List Inbound rules"
}


variable "egress_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR Outbound"

  validation {
    condition     = alltrue([for cidr in var.egress_cidr_blocks : can(cidrhost(cidr, 16))])
    error_message = "Must be valid IPv4 CIDR from 10.0.0.0/16 to 255.255.255.255/16"
  }
}

variable "egress_ipv6_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR IPv6 Outbound"
}

variable "egress_rules" {
  type        = list(string)
  default     = []
  description = "List Outbound rules"
}

variable "egress_with_cidr_blocks" {
  type = list(object({
    rule        = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    protocol    = optional(number)
    description = optional(number)
    cidr_blocks = optional(string)
  }))
  default     = []
  description = "List Outbound rules"
}

variable "egress_with_ipv6_cidr_blocks" {
  type = list(object({
    rule        = optional(string)
    from_port   = optional(number)
    to_port     = optional(number)
    protocol    = optional(number)
    description = optional(number)
    cidr_blocks = optional(string)
  }))
  default     = []
  description = "List Outbound rules"
}

variable "egress_with_self" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
  default     = []
  description = "List Outbound rules"
}

variable "egress_with_source_security_group_id" {
  type        = list(map(string))
  default     = []
  description = "List Outbound rules"
}
