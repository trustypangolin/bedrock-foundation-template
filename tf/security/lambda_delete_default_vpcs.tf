resource "aws_cloudwatch_log_group" "delete_default_vpcs_lambda_log_group" {
  name              = format("/aws/lambda/%s", aws_lambda_function.delete_default_vpcs_function.function_name)
  retention_in_days = 3
}

resource "aws_iam_role" "delete_default_vpcs_role" {
  name                 = "bedrock-lambda-delete-default-vpcs"
  max_session_duration = 43200
  managed_policy_arns  = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  assume_role_policy   = data.aws_iam_policy_document.event_lambda.json
  inline_policy {
    name   = "OperationalAssumeMember"
    policy = data.aws_iam_policy_document.cross_account.json
  }
  inline_policy {
    name   = "DeleteDefaultVPCs"
    policy = data.aws_iam_policy_document.deldefvpc.json
  }
  inline_policy {
    name   = "SNSPublish"
    policy = data.aws_iam_policy_document.publish_sns.json
  }
}

data "archive_file" "delete_default_vpcs_lambda_zip" {
  type        = "zip"
  source_file = "./python/delete-default-vpc.py"
  output_path = "./python/delete-default-vpc.zip"
}

resource "aws_lambda_function" "delete_default_vpcs_function" {
  function_name = "bedrock-baseline-delete-default-vpcs"
  description   = "Remove default VPC"
  handler       = "delete-default-vpc.handler"
  runtime       = "python3.8"
  memory_size   = 256
  timeout       = 900
  role          = aws_iam_role.delete_default_vpcs_role.arn
  filename      = "./python/delete-default-vpc.zip"
}



