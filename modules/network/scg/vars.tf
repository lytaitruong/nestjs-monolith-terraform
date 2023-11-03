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
}

variable "ingress_rules" {
  type        = list(string)
  default     = []
  description = "List Inbound rules"
}

variable "ingress_with_cidr_blocks" {
  type        = list(map(string))
  default     = []
  description = "List Inbound rules"
}

variable "ingress_with_self" {
  type        = list(map(string))
  default     = []
  description = "List Outbound rules"
}

variable "ingress_with_source_security_group_id" {
  type        = list(map(string))
  default     = []
  description = "List Outbound rules"
}


variable "egress_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR Inbound"
}

variable "egress_rules" {
  type        = list(string)
  default     = []
  description = "List Outbound rules"
}

variable "egress_with_cidr_blocks" {
  type        = list(map(string))
  default     = []
  description = "List Outbound rules"
}

variable "egress_with_self" {
  type        = list(map(string))
  default     = []
  description = "List Outbound rules"
}

variable "egress_with_source_security_group_id" {
  type        = list(map(string))
  default     = []
  description = "List Outbound rules"
}