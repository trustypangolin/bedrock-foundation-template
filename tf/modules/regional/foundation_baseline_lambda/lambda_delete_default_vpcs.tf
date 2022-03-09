resource "aws_cloudwatch_log_group" "delete_default_vpcs_lambda_log_group" {
  count             = var.baseline_functions["DeleteDefaultVPC"] ? 1 : 0
  name              = format("/aws/lambda/%s", aws_lambda_function.delete_default_vpcs_function[0].function_name)
  retention_in_days = 3
}

resource "aws_iam_role" "delete_default_vpcs_role" {
  count                = var.baseline_functions["DeleteDefaultVPC"] ? 1 : 0
  name                 = format("%s-lambda-delete-default-vpcs", var.bootstrap_prefix)
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
  count       = var.baseline_functions["DeleteDefaultVPC"] ? 1 : 0
  type        = "zip"
  source_file = "${path.module}/python/delete-default-vpc.py"
  output_path = "${path.module}/python/delete-default-vpc.zip"
}

resource "aws_lambda_function" "delete_default_vpcs_function" {
  count         = var.baseline_functions["DeleteDefaultVPC"] ? 1 : 0
  function_name = format("%s-baseline-delete-default-vpcs", var.bootstrap_prefix)
  description   = "Remove default VPC"
  handler       = "delete-default-vpc.handler"
  runtime       = "python3.8"
  memory_size   = 256
  timeout       = 900
  role          = aws_iam_role.delete_default_vpcs_role[0].arn
  filename      = "${path.module}/python/delete-default-vpc.zip"
  environment {
    variables = {
      "ORGLIST" = var.management
      "ROLE"    = format("%s-%s", var.bootstrap_prefix, var.crossrole)
    }
  }
}



