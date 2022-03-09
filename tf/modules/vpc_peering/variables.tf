terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3"
    }
  }
}

variable "prefix" {
  description = "Customer's name for prefixing resources"
  type        = string
}

variable "tags" {
  type = map(string)
}
# ---------------- for VPC Peering ------------------

variable "enable_vpc_peering" {
  description = "Create VPC Peering"
  type        = bool
  default     = false
}

variable "vpc_peering_connections" {
  type = list(object({
    env               = string
    peer_account_id   = string
    peer_vpc_id       = string
    peer_region          = string
    cidr_block        = string
  }))
  description = "List of peering connections"
  default = []
}

// variable "vpc_peering_routes" {
//   type = list(object({
//     env               = string
//     cidr_block        = string
//     vpc_peering_connection_id = string
//   }))
//   description = "List of peering routes"
//   default = []
// }

variable "aws_vpc_id" {
  type        = string
}
