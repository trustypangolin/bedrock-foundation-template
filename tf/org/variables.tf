variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = null
}

variable "unique_prefix" {
  type        = string
  description = "prefix used to be part of resource name"
  default     = null
}

variable "root_emails" {
  description = "root email address for new accounts"
  type        = map(string)
  default     = null
}

variable "notifications" {
  description = "notification email address for new accounts"
  type        = map(string)
  default     = null
}

variable "acc_map" {
  description = "Account Name Mappings where the Account Name differs from the recommeneded names"
  type        = map(string)
  default = {
    Management  = "Management"
    LogArchive  = "Log Archive"
    Security    = "Security"
    Central     = "Central"
    Development = "Development"
    Production  = "Production"
  }
}

variable "tags" {
  description = "Tags to set on resources"
  type        = map(string)
  default = {
    IaC = "Terraform"
  }
}

variable "alt_contacts" {
  description = "Alternate Contacts"
  type        = string
  default     = <<-CSV
  Function,Name,Title,Email,Phone
  finance,Finance Person,CFO,finance@domain.abc,1300 000 000
  BILLING,IT Billing Person,Manager,aws.billing@domain.abc,1300 000 000
  OPERATIONS,IT Ops Person,Ops,aws.operations@domain.abc,0400 000 000
  SECURITY,IT Security Person,Sec,aws.security@domain.abc,0400 000 000
CSV
}

# Org Variables

variable "base_role" {
  type        = string
  description = "Sub Account Role to create/assume."
  default     = null
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

variable "grafana_id" {
  type        = string
  description = "This is your Grafana Cloud identifier and is used for security purposes."
  default     = null
}

variable "control_tower" {
  type        = bool
  description = "Is this a Control Tower setup? Some resources will not be installed"
  default     = false
}

# Customise Entry Roles
variable "bootstrap_prefix" {
  type        = string
  description = "To match customer naming polices, we create a Landing Zone prefix for state, role, dynamodb resources. Typically foundation,bedrock,landingzone etc"
  default     = "bedrock"
}
