variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = "ap-southeast-2"
}

variable "unique_prefix" {
  type        = string
  description = "prefix used to be part of resource name"
}

# variable "tags" {
#   description = "Tags to set on resources"
#   type        = map(string)
#   default = {
#     Version = "1.0.0"
#   }
# }

