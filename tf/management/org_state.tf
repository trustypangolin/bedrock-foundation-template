// Run a terraform apply first, then uncomment this get optional remote state data values
data "terraform_remote_state" "org" {
  backend = "s3"
  config = {
    bucket         = format("%s-tfstate", var.unique_prefix)
    key            = "org"
    region         = "ap-southeast-2"
    dynamodb_table = "bedrock-tfstate"
  }
}

output "acc" {
  value = lookup(data.terraform_remote_state.org.outputs.acc, "Management")
}
