resource "aws_s3_bucket" "log_bucket" {
  bucket = format("%s-logging-%s-%s", var.unique_prefix, data.aws_caller_identity.current.account_id, data.aws_region.current.name)
  #checkov:skip=CKV_AWS_145:No Cross Account
  #checkov:skip=CKV_AWS_144:No Cross Region
  #checkov:skip=CKV_AWS_21:Versioning not required
  #checkov:skip=CKV_AWS_18:This is the logging bucket
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    id = "Purge Logs"
    filter {}
    expiration {
      days = var.expire
    }
    status = "Enabled"
  }
}
resource "aws_s3_bucket_acl" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.log_bucket.json
}

data "aws_iam_policy_document" "log_bucket" {
  statement {
    sid = "AllowSSLRequestsOnly"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect = "Deny"
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.log_bucket.arn,
      format("%s/*", aws_s3_bucket.log_bucket.arn)
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
resource "aws_s3_bucket_public_access_block" "log_bucket" {
  bucket                  = aws_s3_bucket.log_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
