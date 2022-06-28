resource "aws_iam_role" "datasync" {
  name               = format("%s_datasync_%s", var.env, data.aws_region.current.name)
  path               = "/datasync/"
  assume_role_policy = data.aws_iam_policy_document.datasync_trust.json
  inline_policy {
    name   = "AccessS3"
    policy = data.aws_iam_policy_document.s3.json
  }
}

data "aws_iam_policy_document" "datasync_trust" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "datasync.amazonaws.com"
      ]
    }
    effect = "Allow"
    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:datasync:ap-southeast-2:908306807398:*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = ["908306807398"]
    }
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::douugh-tools-central"]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::douugh-tools-central/*"]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObjectTagging",
      "s3:GetObjectTagging",
      "s3:PutObject",
    ]
  }
}
