resource "aws_s3_bucket" "cloudtrail" {
  count  = var.control_tower ? 0 : 1
  bucket = format("%s-cloudtrail", var.unique_prefix)
}

resource "aws_s3_bucket_ownership_controls" "cloudtrail" {
  count  = var.control_tower ? 0 : 1
  bucket = aws_s3_bucket.cloudtrail[0].id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  count                   = var.control_tower ? 0 : 1
  bucket                  = aws_s3_bucket.cloudtrail[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  count  = var.control_tower ? 0 : 1
  bucket = aws_s3_bucket.cloudtrail[0].bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.security_cmk.arn
    }
  }
}

resource "aws_s3_bucket_logging" "cloudtrail" {
  count         = var.control_tower ? 0 : 1
  bucket        = aws_s3_bucket.cloudtrail[0].id
  target_bucket = var.target_bucket
  target_prefix = format("%s/", aws_s3_bucket.cloudtrail[0].id)
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  count  = var.control_tower ? 0 : 1
  bucket = aws_s3_bucket.cloudtrail[0].id
  policy = data.aws_iam_policy_document.cloudtrail[0].json
}

data "aws_iam_policy_document" "cloudtrail" {
  count = var.control_tower ? 0 : 1
  statement {
    sid       = "ForceSSLOnlyAccess"
    effect    = "Deny"
    resources = [format("arn:aws:s3:::%s-cloudtrail/*", var.unique_prefix)]
    actions   = ["s3:*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
  statement {
    sid       = "AWSCloudTrailAclCheck20150319"
    effect    = "Allow"
    resources = [format("arn:aws:s3:::%s-cloudtrail", var.unique_prefix)]
    actions   = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    sid       = "AWSCloudTrailWrite20150319"
    effect    = "Allow"
    resources = [format("arn:aws:s3:::%s-cloudtrail/AWSLogs/*/*", var.unique_prefix)]
    actions   = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    sid    = "PolicyGenerationBucketPolicy"
    effect = "Allow"

    resources = [
      format("arn:aws:s3:::%s-cloudtrail", var.unique_prefix),
      format("arn:aws:s3:::%s-cloudtrail/AWSLogs/%s/$${aws:PrincipalAccount}/*", var.unique_prefix, var.org_id)
    ]
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [var.org_id]
    }
    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::$${aws:PrincipalAccount}:role/service-role/AccessAnalyzerMonitorServiceRole*"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
