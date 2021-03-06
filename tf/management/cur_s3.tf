resource "aws_s3_bucket" "cur" {
  bucket = format("%s-cur", local.unique_prefix)
  #checkov:skip=CKV_AWS_145:No Cross Account
  #checkov:skip=CKV_AWS_144:No Cross Region
  #checkov:skip=CKV_AWS_21:Versioning not required
}

resource "aws_s3_bucket_logging" "cur" {
  bucket        = aws_s3_bucket.cur.id
  target_bucket = module.modules_all_regional.logging
  target_prefix = format("%s/", aws_s3_bucket.cur.id)
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

resource "aws_s3_bucket_lifecycle_configuration" "cur" {
  bucket = aws_s3_bucket.cur.id
  rule {
    id = "Purge Deleted"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 90
    }
    expiration {
      days                         = 0
      expired_object_delete_marker = true
    }
    status = "Enabled"
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
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_cur_report_definition" "cur_report_definition" {
  provider                   = aws.us-east-1 # Resource only support us-east-1 region
  report_name                = "Daily-Cost-and-Usage-Report"
  time_unit                  = "DAILY"
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = aws_s3_bucket.cur.id
  s3_region                  = local.base_region
}

resource "aws_s3_bucket_public_access_block" "cur" {
  bucket                  = aws_s3_bucket.cur.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
