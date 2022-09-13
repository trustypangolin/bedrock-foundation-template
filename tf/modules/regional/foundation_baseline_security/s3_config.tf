resource "aws_s3_bucket" "config_delivery" {
  count  = var.control_tower ? 0 : 1
  bucket = format("%s-config-recordings", var.unique_prefix)
}

resource "aws_s3_bucket_public_access_block" "config_delivery" {
  count                   = var.control_tower ? 0 : 1
  bucket                  = aws_s3_bucket.config_delivery[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config_delivery" {
  count  = var.control_tower ? 0 : 1
  bucket = aws_s3_bucket.config_delivery[0].bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.security_cmk.arn
    }
  }
}

resource "aws_s3_bucket_logging" "config_delivery" {
  count         = var.control_tower ? 0 : 1
  bucket        = aws_s3_bucket.config_delivery[0].id
  target_bucket = var.target_bucket
  target_prefix = format("%s/", aws_s3_bucket.config_delivery[0].id)
}

resource "aws_s3_bucket_policy" "config_delivery" {
  count  = var.control_tower ? 0 : 1
  bucket = aws_s3_bucket.config_delivery[0].id
  policy = data.aws_iam_policy_document.config_delivery[0].json
}

data "aws_iam_policy_document" "config_delivery" {
  count = var.control_tower ? 0 : 1
  statement {
    sid       = "AWSConfigBucketPermissionsCheck"
    effect    = "Allow"
    resources = [format("arn:aws:s3:::%s-config-recordings", var.unique_prefix)]
    actions   = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSConfigBucketExistenceCheck"
    effect    = "Allow"
    resources = [format("arn:aws:s3:::%s-config-recordings", var.unique_prefix)]
    actions   = ["s3:ListBucket"]
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSConfigBucketDelivery"
    effect    = "Allow"
    resources = [format("arn:aws:s3:::%s-config-recordings/AWSLogs/*/Config/*", var.unique_prefix)]
    actions   = ["s3:PutObject"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    sid       = "ForceSSLOnlyAccess"
    effect    = "Deny"
    resources = [format("arn:aws:s3:::%s-config-recordings/*", var.unique_prefix)]
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
}
