variable "gitlab_url" {
  type    = string
  default = "https://gitlab.com"
}

variable "aud_value" {
  type    = string
  default = "https://gitlab.com"
}
variable "match_field" {
  type    = string
  default = "aud"
}
variable "match_github" {
  type = list(any)
}

variable "match_value" {
  type = list(any)
}

variable "assume_role_arn" {
  type = list(any)
}
variable "bitbucket_workspace" {
  type = string
}

variable "bitbucket_workspaceid" {
  type = string
}
