terraform {
  required_providers {
    aws = {
      configuration_aliases = [
        aws.us-east-1
      ]
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
