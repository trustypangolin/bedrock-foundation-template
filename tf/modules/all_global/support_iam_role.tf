# This Keeps Security Hub Happier (CIS.1.20)
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "aws_support" {
  name                 = "bedrock-AWSSupportRole"
  assume_role_policy   = data.aws_iam_policy_document.awssupport_admin.json
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AWSSupportAccess"]
  max_session_duration = 3600
}

data "aws_iam_policy_document" "awssupport_admin" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)]
    }
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}
