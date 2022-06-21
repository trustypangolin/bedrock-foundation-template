resource "aws_organizations_delegated_administrator" "config" {
  provider          = aws.management
  account_id        = data.aws_caller_identity.current.account_id
  service_principal = "config.amazonaws.com"
}

resource "aws_organizations_delegated_administrator" "config-multi" {
  provider          = aws.management
  account_id        = data.aws_caller_identity.current.account_id
  service_principal = "config-multiaccountsetup.amazonaws.com"
}

resource "aws_s3_bucket" "config_delivery" {
  bucket = format("%s-config-recordings", var.unique_prefix)
}

resource "aws_s3_bucket_public_access_block" "config_delivery" {
  bucket                  = aws_s3_bucket.config_delivery.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config_delivery" {
  bucket = aws_s3_bucket.config_delivery.bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.security_cmk.arn
    }
  }
}

resource "aws_s3_bucket_logging" "config_delivery" {
  bucket        = aws_s3_bucket.config_delivery.id
  target_bucket = module.modules_all_regional.logging
  target_prefix = format("%s/", aws_s3_bucket.config_delivery.id)
}

resource "aws_s3_bucket_policy" "config_delivery" {
  bucket = aws_s3_bucket.config_delivery.id
  policy = data.aws_iam_policy_document.config_delivery.json
}

data "aws_iam_policy_document" "config_delivery" {
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
