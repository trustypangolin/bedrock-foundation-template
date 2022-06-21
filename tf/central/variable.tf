variable "unique_prefix" {
  type        = string
  description = "customer name as a prefix used to be part of resource name."
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
    "Management"  = "Management"
    "Security"    = "Security"
    "Central"     = "Central"
    "Production"  = "Production"
    "Development" = "Development"
  }
}

variable "vpccidr" {
  type        = string
  description = "/16 subnet prefix"
  default     = "10.0"
}

variable "grafana_id" {
  type        = string
  description = "This is your Grafana Cloud identifier and is used for security purposes."
  validation {
    condition     = length(var.grafana_id) > 0
    error_message = "ExternalID is required."
  }
}

variable "env" {
  type        = string
  description = "Tag identifier for Operation Account resources"
  default     = "central"
}

variable "enable_ec2_vpn" {
  description = "If set to true, enable the creation of EC2 VPN"
  type        = bool
  default     = false
}
