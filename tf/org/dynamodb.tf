# DynamoDB Terraform state resources
resource "aws_dynamodb_table" "terraform" {
  name         = "bedrock-tfstate"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  point_in_time_recovery {
    enabled = true
  }
  server_side_encryption {
    enabled = true
  }
}
