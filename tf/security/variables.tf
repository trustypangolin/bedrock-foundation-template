variable "state" {
  type = object(
    {
      bucket         = string
      dynamodb_table = string
      key            = string
      region         = string
    }
  )
  # Change this across all projects to match actual state config or set it in terraform.tfvars
  default = {
    bucket         = "indigocapybara-tfstate"
    dynamodb_table = "bedrock-tfstate"
    key            = "bedrock/org"
    region         = "ap-southeast-2"
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
