variable "enable" {
  type = string
  description = "Enable API Gateway"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "name" {
  type        = string
  description = "Name of Security Group"
}

variable "acm_cert_domain" {
  type        = string
  default     = null
  description = "Container Domain Cert"
}

variable "alb_arn" {
  type        = string
  description = "Arns of Application Load Balancer"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group of Application Load Balancer"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets of Application Load Balancer"
}
