terraform {
  required_providers {
    aws = {
    }
  }
}

data "aws_region" "current" {}
data "aws_regions" "current" {}
data "aws_caller_identity" "current" {}
