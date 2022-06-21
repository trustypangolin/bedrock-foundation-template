resource "aws_iam_role" "bedrock" {
  name                 = "bedrock-deploy"
  assume_role_policy   = data.aws_iam_policy_document.bedrock_trust.json
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  max_session_duration = 43200
}

data "aws_iam_policy_document" "bedrock_trust" {
  dynamic "statement" {
    for_each = var.gitlab ? [1] : []
    content {
      actions = [
        "sts:AssumeRole"
      ]
      principals {
        type        = "AWS"
        identifiers = [aws_iam_role.gitlab_ci[0].arn]
      }
    }
  }
  dynamic "statement" {
    for_each = var.github ? [1] : []
    content {
      actions = [
        "sts:AssumeRole"
      ]
      principals {
        type        = "AWS"
        identifiers = [aws_iam_role.github_ci[0].arn]
      }
    }
  }
  dynamic "statement" {
    for_each = var.bitbucket ? [1] : []
    content {
      actions = [
        "sts:AssumeRole"
      ]
      principals {
        type        = "AWS"
        identifiers = [aws_iam_role.bitbucket_ci[0].arn]
      }
    }
  }
}
