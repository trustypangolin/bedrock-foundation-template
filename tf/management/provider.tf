terraform {
  required_version = "~> 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# import the outputs (accounts ids) from org remote state
data "terraform_remote_state" "org" {
  backend = "s3"
  config  = var.state
}

data "aws_regions" "current" {}
data "aws_caller_identity" "current" {}

provider "aws" {
  region = local.workspace["base_region"]
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
    session_name = "terraform"
  }
  default_tags {
    tags = local.workspace["tags"]
  }
}

