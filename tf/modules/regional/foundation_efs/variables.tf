variable "unique_prefix" {
  type        = string
  description = "The name of the customer"
}

variable "env" {
  type        = string
  description = "The name of the environment"
}

variable "instance_group" {
  type        = string
  default     = "default"
  description = "The name of the instances that you consider as a group"
}

variable "vpc" {
  type = object(
    {
      vpc_id  = string,
      cidr    = string,
      public  = object({ subnet_cidrs = list(string), subnet_ids = list(string), routetable_ids = list(string) }),
      private = object({ subnet_cidrs = list(string), subnet_ids = list(string), routetable_ids = list(string) }),
      public  = object({ subnet_cidrs = list(string), subnet_ids = list(string), routetable_ids = list(string) }),
    }
  )
}
