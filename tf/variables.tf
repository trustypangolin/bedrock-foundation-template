variable "base_region" {
  type        = string
  description = "AWS region to operate in. Defaults to ap-southeast-2 (Sydney)."
  default     = "ap-southeast-2"
}

variable "unique_prefix" {
  type        = string
  description = "unique prefix used to be part of resource name"
}

# GitLab OIDC variables
variable "gitlab" {
  type    = bool
  default = true
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
  type = list(any)
}


# GitHub OIDC variables
variable "github" {
  type    = bool
  default = true
}

variable "github_match" {
  type = list(string)
}

variable "github_field" {
  type    = string
  default = "sub"
}

# BitBucket OIDC variables
variable "bitbucket" {
  type    = bool
  default = true
}

variable "bitbucket_workspace" {
  type = string
}

variable "bitbucket_workspaceid" {
  type = string
}

