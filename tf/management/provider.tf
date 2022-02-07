terraform {
  required_version = "~> 1.1.0"
}

provider "aws" {
  region = var.base_region
  default_tags {
    Bedrock = "3.0.0"
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
