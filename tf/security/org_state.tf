// import the outputs (accounts ids) from org remote state
data "terraform_remote_state" "org" {
  backend = "s3"
  config = {
    bucket         = format("%s-tfstate", var.unique_prefix)
    key            = "org"
    region         = "ap-southeast-2"
    dynamodb_table = "bedrock-tfstate"
  }
}
