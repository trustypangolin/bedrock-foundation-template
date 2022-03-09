variable "unique_prefix" {
  type        = string
  description = "customer name as a prefix used to be part of resource name. (e.g. itoc-vpc)"
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
    Version = "3.0.0"
  }
}
