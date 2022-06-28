data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket" "flow_logs" {
  bucket = format("%s-flow-logs", local.unique_prefix)
}

resource "aws_s3_bucket_acl" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id
  access_control_policy {
    owner {
      id = data.aws_canonical_user_id.current.id
    }
    grant {
      grantee {
        type = "CanonicalUser"
        id   = data.aws_canonical_user_id.current.id
      }
      permission = "FULL_CONTROL"
    }

    # Allows CloudFront to send its logs here
    grant {
      grantee {
        type = "CanonicalUser"
        id   = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
      }
      permission = "FULL_CONTROL"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id
  rule {
    id = "Purge Logs"
    filter {}
    expiration {
      days = var.expire
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "flow_logs" {
  bucket                  = aws_s3_bucket.flow_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.security_cmk.arn
    }
  }
}

resource "aws_s3_bucket_logging" "flow_logs" {
  bucket        = aws_s3_bucket.flow_logs.id
  target_bucket = module.modules_all_regional.logging
  target_prefix = format("%s/", aws_s3_bucket.flow_logs.id)
}

resource "aws_s3_bucket_policy" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id
  policy = data.aws_iam_policy_document.flow_logs.json
}

data "aws_iam_policy_document" "flow_logs" {
  statement {
    sid       = "ForceSSLOnlyAccess"
    effect    = "Deny"
    resources = [format("arn:aws:s3:::%s-flow-logs/*", local.unique_prefix)]
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
    sid       = "AWSLogDeliveryWrite"
    effect    = "Allow"
    resources = [format("arn:aws:s3:::%s-flow-logs/*", local.unique_prefix)]
    actions   = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
  statement {
    sid       = "AWSLogDeliveryCheck"
    effect    = "Allow"
    resources = [format("arn:aws:s3:::%s-flow-logs", local.unique_prefix)]
    actions   = ["s3:GetBucketAcl", "s3:ListBucket"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }

  statement {
    sid       = "AllowCloudFront"
    effect    = "Allow"
    resources = [format("arn:aws:s3:::%s-flow-logs", local.unique_prefix)]
    actions   = ["s3:GetBucketAcl", "s3:PutBucketAcl"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.terraform_remote_state.org.outputs.org_id]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
