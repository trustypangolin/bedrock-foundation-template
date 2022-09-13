variable "state" {
  type = object(
    {
      bucket         = string
      dynamodb_table = string
      key            = string
      region         = string
    }
  )
  # Change this across all projects to match actual state config or set it in terraform.tfvars
  default = {
    bucket         = "indigocapybara-tfstate"
    dynamodb_table = "bedrock-tfstate"
    key            = "bedrock/org"
    region         = "ap-southeast-2"
  }
}
