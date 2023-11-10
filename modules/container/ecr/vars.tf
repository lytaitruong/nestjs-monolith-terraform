variable "enable" {
  type = bool
  description = "Enable ECR"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "name" {
  type        = string
  description = "Name of ECR Repository"
}
