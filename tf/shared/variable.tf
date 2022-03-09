variable "unique_prefix" {
  type        = string
  description = "customer name as a prefix used to be part of resource name."
}

variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = "ap-southeast-2"
}

variable "tags" {
  description = "Tags to set on resources"
  type        = map(string)
  default = {
    IaC = "Terraform"
  }
}
variable "vpccidr" {
  type        = string
  description = "/16 subnet prefix"
  default     = "10.0"
}
# variable "crossaccountrole" {
#   description = "cross account role for Custom Lambda Functions"
#   type        = map(string)
#   default = ({
#     "lambda"    = "bedrock-MemberLambdaRemote"
#     "scheduler" = "bedrock-SchedulerRemote"
#   })
# }

# variable "lambdacron" {
#   description = "Lambda cadence"
#   type        = map(string)
# }

# variable "lambdaregions" {
#   description = "Lambda cadence"
#   type        = map(string)
# }

# variable "lambdaparams" {
#   description = "Lambda cadence"
#   type        = map(string)
# }

# variable "scheduler_time_zone" {
#   description = "Scheduler Time Zone"
#   type        = string
#   default     = "Australia/Sydney"
# }

# variable "resourcetag" {
#   description = "tagged resources"
#   type        = string
#   default     = "shared"
# }

# variable "cidrprefix" {
#   description = "CIDR range"
#   type        = string
#   default     = "10.70"
# }

# variable "numbernatgw" {
#   description = "Number of NAT Gateways"
#   type        = string
#   default     = 0
# }

# variable "enable_ec2_vpn" {
#   description = "If set to true, enable the creation of EC2 VPN"
#   type        = bool
#   default     = false
# }

# variable "log_group" {
#   type        = string
#   description = "log_group of cloudtrail"
# }
