variable "env" {
  type        = string
  description = "Environment"
}

variable "name" {
  type        = string
  description = "Name of Identifier"
}

variable "enable" {
  type        = bool
  description = "Elastic Cache enable"
  default     = false
}

variable "enable_cluster" {
  type        = bool
  description = "Elastic Cache mode Cluster or Single"
  default     = false
}

variable "node_type" {
  type        = string
  description = "Elasticache Instance type"
}

variable "node_number_cache" {
  type        = number
  description = "Elasticache Cache nodes number"
  default     = 1
}

variable "replicas_per_node_group" {
  type        = number
  description = "Elastic Replicate Group Per Node"
  default     = 1
}

variable "subnet_group_name" {
  type        = string
  description = "Elasticache List Subnets"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Elasticache List Security Groups"
}
