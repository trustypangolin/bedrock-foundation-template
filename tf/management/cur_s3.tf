resource "aws_s3_bucket" "log_bucket" {
  bucket = format("%s-logging", var.unique_prefix)
  acl    = "log-delivery-write"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  #checkov:skip=CKV_AWS_145:No Cross Account
  #checkov:skip=CKV_AWS_144:No Cross Region
  #checkov:skip=CKV_AWS_21:Versioning not required
  #checkov:skip=CKV_AWS_18:This is the logging bucket
}

resource "aws_s3_bucket" "cur" {
  bucket = format("%s-cur", var.unique_prefix)
  # acl    = "private"
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
  #checkov:skip=CKV_AWS_145:No Cross Account
  #checkov:skip=CKV_AWS_144:No Cross Region
  #checkov:skip=CKV_AWS_21:Versioning not required
}

resource "aws_s3_bucket_acl" "cur" {
  bucket = aws_s3_bucket.cur.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "cur" {
  bucket = aws_s3_bucket.cur.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cur" {
  bucket = aws_s3_bucket.cur.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "cur" {
  bucket = aws_s3_bucket.cur.id
  policy = data.aws_iam_policy_document.cur.json
}

data "aws_iam_policy_document" "cur" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      format("%s/*", aws_s3_bucket.cur.arn)
    ]
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy"
    ]
    resources = [
      aws_s3_bucket.cur.arn
    ]
  }

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
      aws_s3_bucket.cur.arn,
      format("%s/*", aws_s3_bucket.cur.arn)
    ]
    condition {
      test     = "aws:SecureTransport"
      variable = "Bool"
      values = [
        "false"
      ]
    }
  }
}

resource "aws_cur_report_definition" "cur_report_definition" {
  provider                   = aws.us-east-1 # Resource only support us-east-1 region
  report_name                = "Hourly-Cost-and-Usage-Report"
  time_unit                  = "DAILY"
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = aws_s3_bucket.cur.id
  s3_region                  = var.base_region
}

resource "aws_s3_bucket_public_access_block" "cur" {
  bucket                  = aws_s3_bucket.cur.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "log_bucket" {
  bucket                  = aws_s3_bucket.log_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
