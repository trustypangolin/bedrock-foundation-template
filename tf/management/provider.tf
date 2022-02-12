terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  # assume_role {
  #   role_arn     = "arn:aws:iam::${lookup(data.terraform_remote_state.org.outputs.acc, "Management")}:role/GitLab-Admin"
  #   session_name = "terraform"
  # }
  default_tags {
    tags = {
      Service = "Bedrock"
    }
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  default_tags {
    tags = {
      Service = "Bedrock"
    }
  }
}
