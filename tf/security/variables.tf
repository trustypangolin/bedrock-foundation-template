variable "unique_prefix" {
  type        = string
  description = "prefix used to be part of resource name"
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

variable "notifications" {
  description = "SNS Emails"
  type        = map(string)
}

variable "grafana_id" {
  type        = string
  description = "This is your Grafana Cloud identifier and is used for security purposes."
  validation {
    condition     = length(var.grafana_id) > 0
    error_message = "ExternalID is required."
  }
}

variable "crossrole" {
  type        = string
  description = "Cross Account Lambda Role Name"
  default     = "bedrock-central-lambda-remote"
}

variable "baseline_functions" {
  type        = map(string)
  description = "Activation of baseline lambda functions. Some Functions are destructive when imported into AWS Accounts"
  default = {
    "DeleteDefaultVPC"    = false
    "SnapshotSizeManager" = true
    "SnapshotTagManager"  = true
    "InstanceScheduler"   = true
  }
}

variable "expire" {
  type        = number
  description = "Log Expiry Time"
  default     = 365
}
