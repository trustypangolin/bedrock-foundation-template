terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  default_tags {
    tags = {
      Service = "Bedrock"
    }
  }
}

