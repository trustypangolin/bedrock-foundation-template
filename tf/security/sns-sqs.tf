resource "aws_sns_topic" "bedrock-operations" {
  name = "bedrock-operations"
}

resource "aws_sns_topic_policy" "bedrock-operations" {
  arn    = aws_sns_topic.bedrock-operations.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "bedrock-operations" {
  topic_arn = aws_sns_topic.bedrock-operations.arn
  protocol  = "email"
  endpoint  = var.notifications["operations"]
}

resource "aws_sns_topic" "bedrock-security" {
  name = "bedrock-security"
}

resource "aws_sns_topic_policy" "bedrock-security" {
  arn    = aws_sns_topic.bedrock-security.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "bedrock-security" {
  topic_arn = aws_sns_topic.bedrock-security.arn
  protocol  = "email"
  endpoint  = var.notifications["security"]
}

resource "aws_sns_topic" "bedrock-deadletter" {
  name = "bedrock-deadletter"
}

resource "aws_sns_topic_policy" "bedrock-deadletter" {
  arn    = aws_sns_topic.bedrock-deadletter.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sqs_queue" "bedrock-deadletter" {
  name = "bedrock-deadletter"
}

resource "aws_sns_topic_subscription" "bedrock-deadletter" {
  topic_arn = aws_sns_topic.bedrock-deadletter.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.bedrock-deadletter.arn
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
