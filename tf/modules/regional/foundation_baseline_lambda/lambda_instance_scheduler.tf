locals {
  cross_account_roles = join(",", [
    for account in var.operational : format(
      "arn:aws:iam::%s:role/%s-SchedulerRemote",
      account,
      var.bootstrap_prefix
    )
    ]
  )

  active_regions = var.scheduler_params["Regions"] == "SingleOnly" ? data.aws_region.current.name : join(",", [
    for region in data.aws_regions.current.names : format(
      format("%s", region)
    )
    ]
  )
}

resource "aws_cloudformation_stack" "instance_scheduler" {
  count        = var.baseline_functions["InstanceScheduler"] ? 1 : 0
  name         = format("%s-instance-scheduler", var.bootstrap_prefix)
  capabilities = ["CAPABILITY_NAMED_IAM"]
  on_failure   = "ROLLBACK"
  parameters = {
    Prefix                   = var.bootstrap_prefix
    Regions                  = local.active_regions
    CrossAccountRoles        = local.cross_account_roles
    SchedulerFrequency       = var.scheduler_params["SCHEDULER_FREQUENCY"]
    DefaultTimezone          = "Australia/Brisbane"
    SNSNotificationAccountId = data.aws_caller_identity.current.id
  }
  template_body = file("${path.module}/cloudformation/aws-instance-scheduler.yml")

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}


# Most of the CloudFormation Resources are rewritten here, but there is a custom resource in CloudFormation tied to Lambda making this not really usable jsut yet
# LOG_GROUP = aws_cloudwatch_log_group.scheduler
# resource "aws_cloudwatch_log_group" "scheduler" {
#   count             = var.baseline_functions["InstanceScheduler"] ? 1 : 0
#   name              = format("/aws/lambda/%s-AWS-Instance-Scheduler", var.bootstrap_prefix)
#   retention_in_days = 3
# }

# resource "aws_iam_role" "scheduler" {
#   count               = var.baseline_functions["InstanceScheduler"] ? 1 : 0
#   name                = format("%s-AWS-Instance-Scheduler", var.bootstrap_prefix)
#   assume_role_policy  = data.aws_iam_policy_document.assume_scheduler.json
#   managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

#   inline_policy {
#     name   = "Xray"
#     policy = data.aws_iam_policy_document.scheduler_xray.json
#   }

#   inline_policy {
#     name   = "DynamoDB"
#     policy = data.aws_iam_policy_document.scheduler_dynamodb.json
#   }

#   inline_policy {
#     name   = "SSM"
#     policy = data.aws_iam_policy_document.scheduler_ssm.json
#   }
# }

# data "aws_iam_policy_document" "assume_scheduler" {
#   statement {
#     actions = [
#       "sts:AssumeRole",
#     ]
#     principals {
#       type = "Service"
#       identifiers = [
#         "lambda.amazonaws.com",
#         "events.amazonaws.com"
#       ]
#     }
#     effect = "Allow"
#   }
# }

# data "aws_iam_policy_document" "scheduler_xray" {
#   statement {
#     actions = [
#       "xray:PutTraceSegments",
#       "xray:PutTelemetryRecords"
#     ]
#     effect    = "Allow"
#     resources = ["*"]
#   }
# }

# data "aws_iam_policy_document" "scheduler_dynamodb" {
#   statement {
#     actions = [
#       "dynamodb:BatchGetItem",
#       "dynamodb:GetRecords",
#       "dynamodb:GetShardIterator",
#       "dynamodb:Query",
#       "dynamodb:GetItem",
#       "dynamodb:Scan",
#       "dynamodb:ConditionCheckItem",
#       "dynamodb:BatchWriteItem",
#       "dynamodb:PutItem",
#       "dynamodb:UpdateItem",
#       "dynamodb:DeleteItem",
#     ]
#     resources = ["*"] # needs to be the dynamo State Table instead
#     effect    = "Allow"
#   }

#   statement {
#     actions = [
#       "dynamodb:DeleteItem",
#       "dynamodb:GetItem",
#       "dynamodb:PutItem",
#       "dynamodb:Query",
#       "dynamodb:Scan",
#       "dynamodb:BatchWriteItem",
#     ]
#     effect    = "Allow"
#     resources = ["*"] # needs to be ConfigTable and MaintTables
#   }
# }

# data "aws_iam_policy_document" "scheduler_ssm" {
#   statement {
#     actions = [
#       "ssm:PutParameter",
#       "ssm:GetParameter",
#     ]
#     effect = "Allow"
#     resources = [
#       "arn:*:ssm:*:*:parameter/Solutions/aws-instance-scheduler/UUID/*"
#     ]
#   }
# }

# resource "aws_lambda_function" "scheduler" {
#   count         = var.baseline_functions["InstanceScheduler"] ? 1 : 0
#   function_name = format("%s-InstanceSchedulerMain", var.bootstrap_prefix)
#   description   = "EC2 and RDS instance scheduler, version v1.4.1"
#   handler       = "main.lambda_handler"
#   runtime       = "python3.8"
#   memory_size   = 128
#   timeout       = 900
#   role          = aws_iam_role.scheduler[0].arn
#   s3_bucket     = format("solutions-%s", data.aws_region.current.name)
#   s3_key        = "aws-instance-scheduler/v1.4.1/instance-scheduler.zip"
#   environment {
#     variables = {
#       # Prebuilt Options
#       BOTO_RETRY                     = "5,10,30,0.25"
#       ENABLE_SSM_MAINTENANCE_WINDOWS = "True"
#       ENV_BOTO_RETRY_LOGGING         = "FALSE"
#       ISSUES_TOPIC_ARN               = ""
#       SOLUTION_ID                    = "S00030"
#       SEND_METRICS                   = "False"
#       METRICS_URL                    = "https://metrics.awssolutionsbuilder.com/generic"
#       TRACE                          = "False"
#       USER_AGENT                     = "InstanceScheduler-v1.4.1"
#       USER_AGENT_EXTRA               = "AwsSolution/SO0030/v1.4.1"
#       UUID_KEY                       = "/Solutions/aws-instance-scheduler/UUID/"
#       START_EC2_BATCH_SIZE           = "5"

#       # Variable Options
#       SCHEDULER_FREQUENCY = var.scheduler_params["SCHEDULER_FREQUENCY"]
#       TAG_NAME            = var.scheduler_params["TAG_NAME"]

#       # Terraform Reference Options
#       ACCOUNT                  = data.aws_caller_identity.current.id
#       CONFIG_TABLE             = aws_dynamodb_table.config[0].name
#       DDB_TABLE_NAME           = ""
#       LOG_GROUP                = aws_cloudwatch_log_group.scheduler[0].name
#       MAINTENANCE_WINDOW_TABLE = aws_dynamodb_table.maintenance[0].name
#       STACK_ID                 = aws_cloudformation_stack.instance_scheduler[0].id
#       STACK_NAME               = aws_cloudformation_stack.instance_scheduler[0].name
#       STATE_TABLE              = aws_dynamodb_table.state[0].name
#     }
#   }
# }




# resource "aws_cloudwatch_event_rule" "scheduler" {
#   count               = var.baseline_functions["InstanceScheduler"] ? 1 : 0
#   name                = format("%s-instance-scheduler-SchedulerRule-1C61GUY1HDJGE", var.bootstrap_prefix)
#   description         = "Instance Scheduler - Rule to trigger instance for scheduler function version v1.4.1"
#   schedule_expression = "cron(0/5 * * * ? *)"
# }

# resource "aws_cloudwatch_event_target" "scheduler" {
#   count     = var.baseline_functions["InstanceScheduler"] ? 1 : 0
#   rule      = aws_cloudwatch_event_rule.scheduler[0].name
#   target_id = "Target0"
#   arn       = aws_lambda_function.scheduler[0].arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   count         = var.baseline_functions["InstanceScheduler"] ? 1 : 0
#   statement_id  = "AllowExecutionFromEventBridge"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.scheduler[0].function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.scheduler[0].arn
# }





# resource "aws_dynamodb_table" "state" {
#   count          = var.baseline_functions["InstanceScheduler"] ? 1 : 0
#   name           = "foundation-instance-scheduler-r-StateTable-MY9PHLJA40SF"
#   billing_mode   = "PAY_PER_REQUEST"
#   read_capacity  = 0
#   write_capacity = 0
#   hash_key       = "service"
#   range_key      = "account-region"

#   attribute {
#     name = "service"
#     type = "S"
#   }

#   attribute {
#     name = "account-region"
#     type = "S"
#   }

#   point_in_time_recovery {
#     enabled = true
#   }
# }

# resource "aws_dynamodb_table" "config" {
#   count          = var.baseline_functions["InstanceScheduler"] ? 1 : 0
#   name           = "foundation-instance-scheduler-r-ConfigTable-18W4DCGWAIUHL"
#   billing_mode   = "PAY_PER_REQUEST"
#   read_capacity  = 0
#   write_capacity = 0
#   hash_key       = "type"
#   range_key      = "name"

#   attribute {
#     name = "name"
#     type = "S"
#   }

#   attribute {
#     name = "type"
#     type = "S"
#   }

#   point_in_time_recovery {
#     enabled = true
#   }
# }

# resource "aws_dynamodb_table" "maintenance" {
#   count          = var.baseline_functions["InstanceScheduler"] ? 1 : 0
#   name           = "foundation-instance-scheduler-r-MaintenanceWindowTable-9ON2X28FIJNC"
#   billing_mode   = "PAY_PER_REQUEST"
#   read_capacity  = 0
#   write_capacity = 0
#   hash_key       = "Name"
#   range_key      = "account-region"

#   attribute {
#     name = "Name"
#     type = "S"
#   }

#   attribute {
#     name = "account-region"
#     type = "S"
#   }

#   point_in_time_recovery {
#     enabled = true
#   }
# }

