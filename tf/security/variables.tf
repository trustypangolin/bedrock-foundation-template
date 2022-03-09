variable "unique_prefix" {
  type        = string
  description = "prefix used to be part of resource name"
}

variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = "ap-southeast-2"
}

variable "tags" {
  description = "Tags to set on resources"
  type        = map(string)
  default = {
    IaC = "Terraform"
  }
}

variable "notifications" {
  description = "SNS Emails"
  type        = map(string)
}