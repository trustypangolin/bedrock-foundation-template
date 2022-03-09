#====================================================================================================
# Description : Terraform state files for this project are stored in S3 with locking done using a DynamoDB table in Management Account.
# Author      : Itoc (Benjamin Luton)
# Date        : 2021-08-01
# Version     : 1.0.0
#====================================================================================================

// Run a terraform apply first, then uncomment this get optional remote state data values
// data "terraform_remote_state" "network" {
//   backend = "s3"
//   config = {
//     bucket         = join("-", [
//       var.customer_prefix,
//       "tfstate"
//       ])
//     key            = "peering" 
//     region         = "ap-southeast-2"
//     dynamodb_table = "bedrock-tfstate"
//   }
// }

# ============= import the outputs (network ids) from org remote state ======================================
data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = join("-", [
      var.customer_prefix,
      "tfstate"
    ])
    key            = "shared"
    region         = "ap-southeast-2"
    dynamodb_table = "bedrock-tfstate"
  }
}

# ============= import the outputs (network ids) from org remote state ======================================
data "terraform_remote_state" "prod" {
  backend = "s3"
  config = {
    bucket = join("-", [
      var.customer_prefix,
      "tfstate"
    ])
    key            = "prod"
    region         = "ap-southeast-2"
    dynamodb_table = "bedrock-tfstate"
  }
}

data "terraform_remote_state" "staging" {
  backend = "s3"
  config = {
    bucket = join("-", [
      var.customer_prefix,
      "tfstate"
    ])
    key            = "staging"
    region         = "ap-southeast-2"
    dynamodb_table = "bedrock-tfstate"
  }
}

data "terraform_remote_state" "development" {
  backend = "s3"
  config = {
    bucket = join("-", [
      var.customer_prefix,
      "tfstate"
    ])
    key            = "development"
    region         = "ap-southeast-2"
    dynamodb_table = "bedrock-tfstate"
  }
}

// manually change this file to upload an org object to s3
// this object will be used in the bedrock to reference actual account numbers
terraform {
  backend "s3" {
    //    bucket         = "%CUSTOMERPREFIX%-tfstate" # we send this as a command line param, so this isnt needed, eg terraform init -backend-config="bucket=customer-tfstate"
    key            = "peering"
    region         = "ap-southeast-2"
    dynamodb_table = "bedrock-tfstate"
  }
}
