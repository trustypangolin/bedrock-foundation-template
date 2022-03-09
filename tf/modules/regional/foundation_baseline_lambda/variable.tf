variable "crossrole" {
  type        = string
  description = "Cross Account Lambda Role Name"
  default     = "central-lambda-remote"
}

variable "management" {
  type        = string
  description = "Management Account Id, This is used to iterate Account Ids from within Lambda itself"
}

variable "operational" {
  type        = list(string)
  description = "Operational Accounts the Lambdas will operate in"
}

variable "baseline_functions" {
  type        = map(string)
  description = "Activation of baseline lambda functions. Some Functions are destructive when imported into AWS Accounts"
  default = {
    "DeleteDefaultVPC"    = true
    "SnapshotSizeManager" = true
    "SnapshotTagManager"  = true
    "InstanceScheduler"   = true
  }
}

variable "scheduler_params" {
  type        = map(string)
  description = "Some Scheduler Parameters, most of these are prefilled"
  default = {
    SCHEDULER_FREQUENCY = 15
    TAG_NAME            = "Schedule"
    Regions             = "SingleOnly"
    custom_schedules    = "No" # This must be set to No on first Run
  }
}

variable "bootstrap_prefix" {
  type        = string
  description = "Role Prefix"
  default     = "bedrock"
}

variable "snsarn" {
  type = map(string)
  description = "SNS topic for deadletter, must be in the same region"
}