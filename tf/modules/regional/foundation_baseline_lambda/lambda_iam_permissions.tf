data "aws_iam_policy_document" "cross_account" {
  statement {
    sid = "AssumeCrossAccountRoles"
    actions = [
      "sts:*",
    ]
    resources = [
      format("arn:aws:iam::*:role/%s-%s", var.bootstrap_prefix, var.crossrole)
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "event_lambda" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "publish_sns" {
  statement {
    sid = "defaultstatementID"
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]
    resources = [
      "arn:aws:sns:*:*:bedrock*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "publish_sqs" {
  statement {
    sid = "defaultstatementID"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:ChangeMessageVisibility"
    ]
    resources = [
      "arn:aws:sqs:*:*:bedrock*",
      "arn:aws:sqs:*:*:bedrock*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ec2tagmanager" {
  statement {
    sid = "ec2tagmanager"
    actions = [
      "ec2:Describe*",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "tags:GetResources"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "snapshotsize" {
  statement {
    sid = "ec2tagmanager"
    actions = [
      "ec2:Describe*",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "tags:GetResources"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }

  statement {
    sid = "BlockDifference"
    actions = [
      "ebs:ListChangedBlocks"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "removerules" {
  statement {
    sid = "ec2tagmanager"
    actions = [
      "ec2:Describe*",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:CreateTags",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DeleteRoute",
      "ec2:DeleteNetworkAclEntry"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "deldefvpc" {
  statement {
    sid = "deleteec2resource"
    actions = [
      "ec2:DescribeInternetGateways",
      "ec2:DeleteSubnet",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRegions",
      "ec2:DescribeAccountAttributes",
      "ec2:DeleteVpc",
      "ec2:DetachInternetGateway",
      "ec2:DescribeSubnets",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }

  statement {
    sid = "deletedefaultvpc"
    actions = [
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteNetworkAcl",
      "ec2:DeleteRouteTable"
    ]
    resources = [
      "arn:aws:ec2:*:*:route-table/*",
      "arn:aws:ec2:*:*:security-group/*",
      "arn:aws:ec2:*:*:network-acl/*",
      "arn:aws:ec2:*:*:internet-gateway/*"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid = "lambdakms"
    actions = [
      "kms:*"
    ]
    resources = [
      "arn:aws:kms:*:*:alias/aws/lambda",
      "arn:aws:kms:*:*:alias/aws/ebs",
      "arn:aws:kms:*:*:alias/aws/rds"
    ]
    effect = "Allow"
  }
}

# -- Function execution
#--------------------------------------------------------------------------------------------------
# data "aws_lambda_invocation" "delete_default_vpcs_invoke" {
#   # depends_on    = [module.modules_for_all_accounts]
#   function_name = aws_lambda_function.delete_default_vpcs_function.function_name
#   input = <<JSON
# {
#   "RequestType": "Create",
#   "ResponseURL": "http://pre-signed-S3-url-for-response",
#   "StackId": "arn:aws:cloudformation:ap-southeast-2:123456789012:stack/MyStack/guid",
#   "RequestId": "unique id for this create request",
#   "ResourceType": "Custom::TestResource",
#   "LogicalResourceId": "MyTestResource",
#   "ResourceProperties": {
#     "StackName": "MyStack",
#     "List": [
#       "1",
#       "2",
#       "3"
#     ]
#   }
# }
# JSON
# }
