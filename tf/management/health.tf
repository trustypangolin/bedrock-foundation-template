resource "aws_sns_topic" "ops" {
  name = "bedrock-mgmt-operational"
}

resource "aws_sns_topic_policy" "ops" {
  arn    = aws_sns_topic.ops.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "ops" {
  topic_arn = aws_sns_topic.ops.arn
  protocol  = "email"
  endpoint  = var.notifications["operations"]
}

data "aws_iam_policy_document" "sns_topic_policy" {
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
  rule      = aws_cloudwatch_event_rule.health.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.ops.arn
}
