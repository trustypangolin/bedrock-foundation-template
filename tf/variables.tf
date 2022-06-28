# Mandatory Variables - This must be globally unique, S3 Terraform State will be stored here
variable "unique_prefix" {
  type        = string
  description = "unique prefix used to be part of resource name"
}

variable "source_account" {
  type        = string
  description = "Source SSO Account you are building from, This will be added to the OIDC trust"
  default     = null
}

# Optional Variables - These are retrieved from terraform.tfvars
variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = "ap-southeast-2"
}

# GitLab OIDC variables
variable "gitlab_role" {
  type    = bool
  default = false
}
variable "gitlab_idp" {
  type    = bool
  default = false
}

variable "gitlab_url" {
  type    = string
  default = "https://gitlab.com"
}

variable "gitlab_aud" {
  type    = string
  default = "https://gitlab.com"
}

variable "gitlab_field" {
  type    = string
  default = "sub"
}

variable "gitlab_match" {
  type    = string
  default = null
}


# GitHub OIDC variables
variable "github_role" {
  type    = bool
  default = false
}

variable "github_idp" {
  type    = bool
  default = false
}

variable "github_match" {
  type    = string
  default = null
}

variable "github_field" {
  type    = string
  default = "sub"
}


# BitBucket OIDC variables
variable "bitbucket_role" {
  type    = bool
  default = false
}

variable "bitbucket_idp" {
  type    = bool
  default = false
}

variable "bitbucket_workspace" {
  type    = string
  default = null
}

variable "bitbucket_workspaceid" {
  type    = string
  default = null
}
