resource "aws_kms_key" "security_cmk" {
  description             = "For Security S3 Bucket"
  deletion_window_in_days = 30
  multi_region            = true
  policy                  = data.aws_iam_policy_document.security_cmk.json
}

data "aws_iam_policy_document" "security_cmk" {
  # Default Root account access, DO NOT REMOVE
  statement {
    sid       = "Enable Root Permissions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)]
    }
  }

  # Allow Accounts in the Org general access to the Key
  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ListGrants",
      "kms:ReEncrypt*",
      "kms:RevokeGrant",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [var.org_id]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  # AWS Config Service Role access
  statement {
    sid       = "AWSConfigKMSPolicyService"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    sid    = "AWSConfigKMSPolicyIAM"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [var.org_id]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  # Flow Logs Access
  statement {
    sid       = "Allow VPC Flow Logs to use the key"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }

  # CloudTrail
  statement {
    sid       = "Allow CloudTrail to encrypt logs"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:GenerateDataKey*", "kms:DescribeKey"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_kms_alias" "security_cmk" {
  name          = "alias/security"
  target_key_id = aws_kms_key.security_cmk.key_id
}
