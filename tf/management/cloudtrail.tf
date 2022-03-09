resource "aws_cloudtrail" "org_cloudtrail" {
  name                          = format("%s-cloudtrail", var.unique_prefix)
  s3_bucket_name                = format("%s-cloudtrail", var.unique_prefix)
  kms_key_id                    = format("arn:aws:kms:%s:%s:alias/security", var.base_region, lookup(data.terraform_remote_state.org.outputs.acc, "Security"))
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloud_trail.arn
  cloud_watch_logs_group_arn    = format("%s:*", aws_cloudwatch_log_group.cloudtrail_log_group.arn) # CloudTrail requires the Log Stream wildcard
}

resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name              = "CloudTrail/AWSOrganizationLogGroup"
  retention_in_days = 1
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloud_trail" {
  name               = "cloudtrail-cloudwatch-role"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail.json
  inline_policy {
    name = "CloudTrailLogStream"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid      = "AWSCloudTrailCreateLogStream"
          Action   = ["logs:CreateLogStream"]
          Effect   = "Allow"
          Resource = format("%s:*", aws_cloudwatch_log_group.cloudtrail_log_group.arn)
        },
        {
          Sid      = "AWSCloudTrailPutLogEvents"
          Action   = ["logs:PutLogEvents"]
          Effect   = "Allow"
          Resource = format("%s:*", aws_cloudwatch_log_group.cloudtrail_log_group.arn)
        }
      ]
    })
  }
}
