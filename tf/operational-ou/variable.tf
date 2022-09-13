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

variable "resourcetag" {
  description = "tagged resources"
  type        = string
  default     = "production"
}

variable "cidrprefix" {
  description = "CIDR range"
  type        = string
  default     = "10.100"
}

variable "numbernatgw" {
  description = "Number of NAT Gateways"
  type        = string
  default     = 0
}

variable "log_group" {
  type        = string
  description = "log_group of cloudtrail"
}
