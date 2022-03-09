terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

data "aws_regions" "current" {}
data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "Shared"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
