terraform {
  required_providers {
    aws = {
      configuration_aliases = [
        aws.ap-northeast-1,
        aws.ap-northeast-2,
        aws.ap-south-1,
        aws.ap-southeast-1,
        aws.ap-southeast-2,
        aws.eu-west-1,
        aws.ca-central-1,
        aws.eu-central-1,
        aws.eu-north-1,
        aws.eu-west-2,
        aws.eu-west-3,
        aws.sa-east-1,
        aws.us-east-1,
        aws.us-east-2,
        aws.us-west-1,
        aws.us-west-2,
      ]
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
