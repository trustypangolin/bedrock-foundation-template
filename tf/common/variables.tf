variable "unique_prefix" {
  type        = string
  description = "customer name as a prefix used to be part of resource name. (e.g. central-vpc)"
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
