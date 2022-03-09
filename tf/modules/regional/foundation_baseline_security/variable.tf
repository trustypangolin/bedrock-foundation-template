variable "unique_prefix" {
  type = string
}

variable "base_region" {
  type = string
}

variable "org_id" {
  type = string
}

variable "target_bucket" {
  type = string
}

variable "expire" {
  type        = number
  description = "Log Expiry Time"
  default     = 7
}

variable "notifications" {
  description = "SNS Emails"
  type        = map(string)
}

variable "control_tower" {
  description = "Control Tower"
  type        = bool
  default     = false
}