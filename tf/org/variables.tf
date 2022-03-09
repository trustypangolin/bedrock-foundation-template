variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = "ap-southeast-2"
}

variable "unique_prefix" {
  type        = string
  description = "prefix used to be part of resource name"
}

variable "tags" {
  description = "Tags to set on resources"
  type        = map(string)
  default = {
    IaC = "Terraform"
  }
}

# Org Variables
variable "root_emails" {
  description = "root email address for new accounts"
  type        = map(string)
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
