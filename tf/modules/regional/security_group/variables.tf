variable "name" {
  type = string
}

variable "env" {
  type        = string
  description = "The name of the environment"
}

variable "vpc_id" {
  type        = string
  description = "The VPC id"
}

variable "include_outbound" {
  type        = bool
  description = "required to skip the outbound rule for resources that pre-create it"
  default     = true
}
