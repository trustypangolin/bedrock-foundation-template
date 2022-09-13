variable "unique_prefix" {
  type = string
}

variable "base_region" {
  type = string
}

variable "enable_budgets" {
  type    = bool
  default = true
}

variable "aws_budgets" {
  type        = number
  default     = 50
  description = "Amount to alert when the bill for the whole AWS Organization will exceed on current forecast or has exceeded."
}

variable "enable_health" {
  type    = bool
  default = true
}

variable "notifications" {
  description = "SNS Emails"
  type        = map(string)
}

variable "enable_cur" {
  type    = bool
  default = true
}

variable "target_bucket" {
  type = string
}

variable "enable_cloudtrail" {
  type    = bool
  default = true
}

variable "security" {
  description = "Security Account, Used to accept invites from delegated services"
  type        = string
}
