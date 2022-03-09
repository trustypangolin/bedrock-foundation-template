# Grabs what AZs are available in the region
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}
# data "aws_caller_identity" "current" {}

# ---------------- for VPC ------------------

locals {
  vpc_cidr               = format("%s.0.0/16", var.network_prefix)
  subnet_cidrs           = cidrsubnets(local.vpc_cidr, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)
  azs                    = data.aws_availability_zones.available.names
  number_of_azs          = length(data.aws_availability_zones.available.names)
  number_of_pub_subnets  = length(aws_subnet.public_subnets[*])
  number_of_priv_subnets = length(aws_subnet.private_subnets[*])
  number_of_sec_subnets  = length(aws_subnet.isolated_subnets[*])
}
variable "network_prefix" {
  description = "First two octets for VPC IP range"
  type        = string
}

variable "instance_tenancy" {
  description = "Instance tenancy for VPC"
  type        = string
  default     = "default"
}

variable "env" {
  description = "Workload environment (e.g. shared)"
  type        = string
}

variable "flow_log_bucket_arn" {
  type    = string
  default = ""
}

# ---------------- for NAT Gateway ------------------
variable "number_of_ngws" {
  description = "Number of NAT Gateways to create"
  type        = number
  default     = 0
}

##Endpoints

#Boolean var - SQS endpoint
variable "enable_sqs_endpoint" {
  description = "If set to true, enable the creation of SQS Endpoint"
  type        = bool
  default     = false
}
#Boolean var - SSM endpoint
variable "enable_ssm_endpoint" {
  description = "If set to true, enable the creation of endpoints for ssm, ssmmessages and ec2messages"
  type        = bool
  default     = false
}
#Boolean var - EC2MSG endpoint
variable "enable_ec2messages_endpoint" {
  description = "If set to true, enable the creation of EC2 Messages Endpoint"
  type        = bool
  default     = false
}
#Boolean var - EC2 endpoint
variable "enable_ec2_endpoint" {
  description = "If set to true, enable the creation of EC2 Endpoint"
  type        = bool
  default     = false
}
#Boolean var - APIGW endpoint
variable "enable_apigw_endpoint" {
  description = "If set to true, enable the creation of API GW Endpoint"
  type        = bool
  default     = false
}
#Boolean var - LOGS endpoint
variable "enable_logs_endpoint" {
  description = "If set to true, enable the creation of LOGS Endpoint"
  type        = bool
  default     = false
}
#Boolean var - Monitoring endpoint
variable "enable_monitoring_endpoint" {
  description = "If set to true, enable the creation of Monitoring Endpoint"
  type        = bool
  default     = false
}
