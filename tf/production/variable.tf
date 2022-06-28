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

variable "vpccidr" {
  type        = string
  description = "/16 subnet prefix"
  default     = "10.10"
}

variable "grafana_id" {
  type        = string
  description = "This is your Grafana Cloud identifier and is used for security purposes."
  validation {
    condition     = length(var.grafana_id) > 0
    error_message = "ExternalID is required."
  }
}

variable "env" {
  type        = string
  description = "Tag identifier for Operation Account resources"
  default     = "production"
}
