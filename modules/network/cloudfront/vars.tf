variable "region" {
  type        = string
  description = "AWS Region"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "name" {
  type        = string
  description = "Name of VPC"
}

variable "s3_regional_domain_name" {
  type        = string
  description = "S3 Domain Name"
}

variable "s3_bucket_id" {
  type        = string
  description = "Bucket ID"
}

variable "s3_bucket_arn" {
  type        = string
  description = "S3 ARN"
}

variable "price_class" {
  type    = string
  default = "PriceClass_All"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "Allowed values for input_parameter are \"PriceClass_All\", \"PriceClass_200\", or \"PriceClass_100\"."
  }
}

variable "enable_shield" {
  type    = bool
  default = false
}


variable "trusted_key_groups" {
  type    = list(string)
  default = []
}