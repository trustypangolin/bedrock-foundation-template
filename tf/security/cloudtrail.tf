resource "aws_s3_bucket" "cloudtrail" {
  bucket = format("%s-cloudtrail", local.unique_prefix)
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket                  = aws_s3_bucket.cloudtrail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.security_cmk.arn
    }
  }
}

resource "aws_s3_bucket_logging" "cloudtrail" {
  bucket        = aws_s3_bucket.cloudtrail.id
  target_bucket = module.modules_all_regional.logging
  target_prefix = format("%s/", aws_s3_bucket.cloudtrail.id)
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid       = "ForceSSLOnlyAccess"
    effect    = "Deny"
    resources = [format("arn:aws:s3:::%s-cloudtrail/*", local.unique_prefix)]
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
    resources = [format("arn:aws:s3:::%s-cloudtrail", local.unique_prefix)]
    actions   = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    sid       = "AWSCloudTrailWrite20150319"
    effect    = "Allow"
    resources = [format("arn:aws:s3:::%s-cloudtrail/AWSLogs/*/*", local.unique_prefix)]
    actions   = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}
