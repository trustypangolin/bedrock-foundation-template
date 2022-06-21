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

# For Integration with existing AWS accounts, we need to set these
variable "password_policy" {
  type        = bool
  description = "Apply Default Password Policy"
  default     = true
}

variable "public_s3_block" {
  type        = bool
  description = "Apply S3 Public Access Block Settings"
  default     = true
}

variable "lambda_crossaccount_role" {
  type        = bool
  description = "Lambda Cross Account Role for Remediation Items"
  default     = true
}

