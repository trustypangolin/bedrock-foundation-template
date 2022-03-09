resource "aws_cloudtrail" "org_cloudtrail" {
  count                         = var.enable_cloudtrail ? 1 : 0
  name                          = format("%s-cloudtrail", var.unique_prefix)
  s3_bucket_name                = format("%s-cloudtrail", var.unique_prefix)
  kms_key_id                    = format("arn:aws:kms:%s:%s:alias/security", var.base_region, var.security)
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail[0].arn
  cloud_watch_logs_group_arn    = format("%s:*", aws_cloudwatch_log_group.cloudtrail[0].arn) # CloudTrail requires the Log Stream wildcard
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  count             = var.enable_cloudtrail ? 1 : 0
  name              = "CloudTrail/AWSOrganizationLogGroup"
  retention_in_days = 1
}

data "aws_iam_policy_document" "cloudtrail_trust" {
  count = var.enable_cloudtrail ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloudtrail" {
  count              = var.enable_cloudtrail ? 1 : 0
  name               = "cloudtrail-cloudwatch-role"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_trust[0].json
  inline_policy {
    name   = "CloudTrailLogStream"
    policy = data.aws_iam_policy_document.cloudtrail[0].json
  }
}

data "aws_iam_policy_document" "cloudtrail" {
  count = var.enable_cloudtrail ? 1 : 0
  statement {
    sid = "AWSCloudTrailCreateLogStream"
    actions = [
      "logs:CreateLogStream"
    ]
    effect    = "Allow"
    resources = [format("%s:*", aws_cloudwatch_log_group.cloudtrail[0].arn)]
  }

  statement {
    sid = "AWSCloudTrailPutLogEvents"
    actions = [
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = [format("%s:*", aws_cloudwatch_log_group.cloudtrail[0].arn)]
  }
}

output "name" {
  value = ""
}
