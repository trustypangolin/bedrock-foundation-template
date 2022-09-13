resource "aws_sns_topic" "ops" {
  count = var.enable_health ? 1 : 0
  name  = "bedrock-mgmt-operational"
}

resource "aws_sns_topic_policy" "ops" {
  count  = var.enable_health ? 1 : 0
  arn    = aws_sns_topic.ops[0].arn
  policy = data.aws_iam_policy_document.sns_topic_policy[0].json
}

resource "aws_sns_topic_subscription" "ops" {
  count     = var.enable_health ? 1 : 0
  topic_arn = aws_sns_topic.ops[0].arn
  protocol  = "email"
  endpoint  = var.notifications.operations
}

data "aws_iam_policy_document" "sns_topic_policy" {
  count     = var.enable_health ? 1 : 0
  policy_id = "__default_policy_ID"
  statement {
    actions = [
      "SNS:AddPermission",
      "SNS:DeleteTopic",
      "SNS:GetTopicAttributes",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:Subscribe",
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = ["arn:aws:sns:*:*:bedrock*"]
    sid       = "__default_statement_ID"
  }
}

resource "aws_cloudwatch_event_rule" "health" {
  count         = var.enable_health ? 1 : 0
  name          = "Bedrock-HealthEvent"
  description   = "Personal Health Dashboard"
  event_pattern = <<EOF
{
  "source": [
    "aws.health"
  ],
  "detail-type": [
    "AWS Health Event"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  count     = var.enable_health ? 1 : 0
  rule      = aws_cloudwatch_event_rule.health[0].name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.ops[0].arn
}
