variable "state" {
  type = object(
    {
      bucket         = string
      dynamodb_table = string
      key            = string
      region         = string
    }
  )
  default = {
    bucket         = "bedrock-tfstate"
    dynamodb_table = "bedrock-tfstate"
    key            = "bedrock/org"
    region         = "ap-southeast-2"
  }
}

variable "vpccidr" {
  type        = string
  description = "/16 subnet prefix"
  default     = "10.0"
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
  default     = "central"
}

variable "enable_ec2_vpn" {
  description = "If set to true, enable the creation of EC2 VPN"
  type        = bool
  default     = false
}

variable "number_of_ngws" {
  type    = number
  default = 0
}
