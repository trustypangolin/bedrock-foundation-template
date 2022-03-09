variable "unique_prefix" {
  type        = string
  description = "customer name as a prefix used to be part of resource name. (e.g. s3 : customer-config-recordings)"
}

variable "alias_name" {
  type        = string
  description = "account alias name"
}

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
  default     = null
}

variable "grafana_role_name" {
  type        = string
  default     = "GrafanaLabsCloudWatchIntegration"
  description = "Customize the name of the IAM role used by Grafana for the CloudWatch Integration."
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

variable "iam_account_name" {
  type        = bool
  description = "Set IAM Account Alias"
  default     = true
}

