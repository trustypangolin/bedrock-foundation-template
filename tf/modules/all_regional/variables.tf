variable "unique_prefix" {
  type        = string
  description = "customer name as a prefix used to be part of resource name. (e.g. s3 : customer-config-recordings)"
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

variable "recorder" {
  description = "Activate Recorder"
  type        = bool
  default     = false
}

variable "security" {
  description = "Security Account"
  type        = string
}

variable "aggregate" {
  description = "All Accounts"
  type        = list(string)
  default     = null
}

variable "expire" {
  description = "Logging Bucket Days before deletion"
  type        = number
  default     = 3
}
