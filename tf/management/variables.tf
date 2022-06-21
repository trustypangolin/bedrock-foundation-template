variable "unique_prefix" {
  type        = string
  description = "prefix used to be part of resource name"
}

variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = "ap-southeast-2"
}

variable "acc_map" {
  description = "Account Name Mappings where the Account Name differs from the recommeneded names"
  type        = map(string)
  default = {
    "Management" = "Management"
    "Security"   = "Security"
    "Central"    = "Central"
  }
}

variable "grafana_id" {
  type        = string
  description = "This is your Grafana Cloud identifier and is used for security purposes."
  default     = null
}
