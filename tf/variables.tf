variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = "ap-southeast-2"
}

variable "unique_prefix" {
  type        = string
  description = "unique prefix used to be part of resource name"
}
