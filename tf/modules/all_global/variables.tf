variable "security" {
  description = "Security Account, Used to accept invites from delegated services"
  type        = string
}

variable "central" {
  type        = string
  description = "AWS Account that contains the Central Lambda Functions."
}

variable "crossaccountrole" {
  type        = string
  description = "Cross Account Role"
  default     = "bedrock-central-lambda-remote"
}

variable "grafana_id" {
  type        = string
  description = "This is your Grafana Cloud identifier and is used for security purposes."
  validation {
    condition     = length(var.grafana_id) > 0
    error_message = "ExternalID is required."
  }
}

locals {
  grafana_account_id = "008923505280"
}
