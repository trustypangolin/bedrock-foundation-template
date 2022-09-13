variable "env" {
  type        = string
  description = "The name of the environment"
}

variable "cluster" {
  type        = string
  default     = "default"
  description = "The name of the ECS cluster"
}

variable "instance_group" {
  type        = string
  default     = "default"
  description = "The name of the instances that you consider as a group"
}

variable "vpc" {
  type = object(
    {
      vpc_id   = string,
      cidr     = string,
      public   = object({ subnet_cidrs = list(string), subnet_ids = list(string), routetable_ids = list(string) }),
      private  = object({ subnet_cidrs = list(string), subnet_ids = list(string), routetable_ids = list(string) }),
      isolated = object({ subnet_cidrs = list(string), subnet_ids = list(string), routetable_ids = list(string) }),
    }
  )
}

variable "task_definition_tools" {}
variable "desired_tools_containers" {
  type        = number
  description = "The desired number of containers running the traefik service"
  default     = 1
}

variable "task_definition_web" {}
variable "desired_web_containers" {
  type        = number
  description = "The desired number of containers running the web service"
  default     = 1
}

variable "efs_id" {
  type = string
}
