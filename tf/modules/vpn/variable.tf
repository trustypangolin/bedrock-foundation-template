variable "unique_prefix" {
  type        = string
  description = "customer name as a prefix used to be part of resource name."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "instance_type" {
  type        = string
  description = "Instance Type"
  default     = "t3a.small"
}

variable "env" {
  type        = string
  description = "Environment"

}

variable "backup" {
  type        = bool
  description = "Backup Tag enabled"
  default     = true
}

variable "autossmpatchprod" {
  type        = bool
  description = "Auto Patch Tag enabled"
  default     = true
}

variable "autossmpatchnonprod" {
  type        = bool
  description = "Auto Patch Tag enabled"
  default     = false
}
