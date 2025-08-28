variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = "ap-southeast-2"
}

variable "scheduleprod" {
  type        = string
  description = "Schedule Cron"
  default     = "cron(0 4 ? * THU *)"
}

variable "schedulenonprod" {
  type        = string
  description = "Schedule Cron"
  default     = "cron(0 4 ? * SUN *)"
}

