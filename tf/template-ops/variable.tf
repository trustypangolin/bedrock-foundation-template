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
    IaC = "Terraform"
  }
}

variable "resourcetag" {
  description = "tagged resources"
  type        = string
  default     = "production"
}

variable "cidrprefix" {
  description = "CIDR range"
  type        = string
  default     = "10.100"
}

variable "numbernatgw" {
  description = "Number of NAT Gateways"
  type        = string
  default     = 0
}

variable "log_group" {
  type        = string
  description = "log_group of cloudtrail"
}
