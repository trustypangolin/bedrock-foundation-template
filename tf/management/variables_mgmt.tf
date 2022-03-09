variable "aws_budgets" {
  type        = number
  default     = 50
  description = "Amount to alert when the bill for the whole AWS Organization will exceed on current forecast or has exceeded."
}

variable "backup_regions" {
  description = "Backup data"
  type        = map(string)
  default = {
    r1  = "Sydney"
    r1e = "ap-southeast-2"
    r2  = "London"
    r2e = "eu-west-2"
    r3  = "Oregon"
    r3e = "us-west-2"
  }
}

variable "backup_crons" {
  description = "Backup data"
  type        = map(string)
  default = {
    r1daily   = "cron(0 15 ? * * *)"
    r1weekly  = "cron(0 18 ? * 1 *)"
    r1monthly = "cron(0 21 ? * 1#1 *)"
    r1yearly  = "cron(0 12 1 1 ? *)"

    r2daily   = "cron(0 1 ? * * *)"
    r2weekly  = "cron(0 4 ? * 1 *)"
    r2monthly = "cron(0 19 ? * 1#1 *)"
    r2yearly  = "cron(0 23 1 1 ? *)"

    r3daily   = "cron(0 8 ? * * *)"
    r3weekly  = "cron(0 12 ? * 1 *)"
    r3monthly = "cron(0 15 ? * 1#1 *)"
    r3yearly  = "cron(0 4 1 1 ? *)"
  }
}

variable "notifications" {
  description = "SNS Emails"
  type        = map(string)
}

