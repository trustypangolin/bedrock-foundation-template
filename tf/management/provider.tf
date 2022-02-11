terraform {
  required_version = "~> 1.1.0"
}

provider "aws" {
  region = var.base_region
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
