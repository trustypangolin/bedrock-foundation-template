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

locals {
  management = data.terraform_remote_state.org.outputs.acc[
    lookup(data.terraform_remote_state.org.outputs.acc_map, "Management")
  ]
  security = data.terraform_remote_state.org.outputs.acc[
    lookup(data.terraform_remote_state.org.outputs.acc_map, "Security")
  ]
  central = data.terraform_remote_state.org.outputs.acc[
    lookup(data.terraform_remote_state.org.outputs.acc_map, "Central")
  ]
  # development = data.terraform_remote_state.org.outputs.acc[
  #   lookup(data.terraform_remote_state.org.outputs.acc_map, "Development")
  # ]
  production = data.terraform_remote_state.org.outputs.acc[
    lookup(data.terraform_remote_state.org.outputs.acc_map, "Production")
  ]

  unique_prefix = data.terraform_remote_state.org.outputs.unique_prefix
  base_region   = data.terraform_remote_state.org.outputs.base_region
}

data "aws_regions" "current" {}
data "aws_caller_identity" "current" {}

provider "aws" {
  region = local.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", local.security)
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  alias  = "management"
  region = local.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", local.management)
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
