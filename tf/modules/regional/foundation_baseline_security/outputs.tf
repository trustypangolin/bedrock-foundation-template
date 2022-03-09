output "topics"{
  value = {
    security   = aws_sns_topic.bedrock-security.arn,
    operations = aws_sns_topic.bedrock-operations.arn,
    deadletter = aws_sns_topic.bedrock-deadletter.arn,
  }
}