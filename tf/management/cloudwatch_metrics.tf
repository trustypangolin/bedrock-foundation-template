

# CIS 3.1 Metric Filter/Alarm for unauthorized API calls
resource "aws_cloudwatch_log_metric_filter" "unauthorized_api_calls" {
  name           = format("%s-unauthorized-api-calls", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") } "

  metric_transformation {
    default_value = 0
    name          = format("%s-UnauthorizedApiCallCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-unauthorized-api-calls", var.unique_prefix)
  alarm_description   = "Monitor unauthorized API calls through cloudtrail"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-UnauthorizedApiCallCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
}

# CIS 3.2 Metric Filter/Alarm for console access without MFA
resource "aws_cloudwatch_log_metric_filter" "console_access_without_mfa" {
  name           = format("%s-console-access-without-mfa", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\")}"

  metric_transformation {
    default_value = 0
    name          = format("%s-ConsoleAccessWithoutMfaCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "console_access_without_mfa" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-console-access-without-mfa", var.unique_prefix)
  alarm_description   = "Monitor console logins without mfa"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-ConsoleAccessWithoutMfa", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.3 Metric Filter/Alarm for usage of root account
resource "aws_cloudwatch_log_metric_filter" "root_account_usage" {
  name           = format("%s-root-account-usage", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"

  metric_transformation {
    default_value = 0
    name          = format("%s-RootAccountUsageCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "root_account_usage" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-root-account-usage", var.unique_prefix)
  alarm_description   = "Monitor root account usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-RootAccountUsageCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"

}

# CIS 3.4 Metric Filter/Alarm for IAM policy changes
resource "aws_cloudwatch_log_metric_filter" "iam_policy_change" {
  name           = format("%s-iam-policy-change", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"

  metric_transformation {
    default_value = 0
    name          = format("%s-IamPolicyChangeCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "iam_policy_change" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-iam-policy-change", var.unique_prefix)
  alarm_description   = "Monitor IAM policy changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-IamPolicyChangeCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.5 Metric Filter/Alarm for CloudTrail configuration changes
resource "aws_cloudwatch_log_metric_filter" "cloudtrail_change" {
  name           = format("%s-cloudtrail-change", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"

  metric_transformation {
    default_value = 0
    name          = format("%s-CloudTrailChangeCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail_change" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-cloudtrail-change", var.unique_prefix)
  alarm_description   = "Monitor CloudTrail configuration changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-CloudTrailChangeCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.6 Metric Filter/Alarm for failed console logins
resource "aws_cloudwatch_log_metric_filter" "failed_console_login" {
  name           = format("%s-failed-console-login", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{($.eventName=ConsoleLogin) && ($.errorMessage=\"Failed authentication\")}"

  metric_transformation {
    default_value = 0
    name          = format("%s-FailedConsoleLoginCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "failed_console_login" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-failed-console-login", var.unique_prefix)
  alarm_description   = "Monitor failed console logins"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-FailedConsoleLoginCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.7 Metric Filter/Alarm for disabled or deleted KMS keys
resource "aws_cloudwatch_log_metric_filter" "disable_or_delete_cmk" {
  name           = format("%s-disable-or-delete-cmk", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{($.eventSource = kms.amazonaws.com) && (($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion)) }"

  metric_transformation {
    default_value = 0
    name          = format("%s-DisableOrDeleteCmkCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "disable_or_delete_cmk" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-disable-or-delete-cmk", var.unique_prefix)
  alarm_description   = "Monitor disabled or deleted KMS keys"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-DisableOrDeleteCmkCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.8 Metric Filter/Alarm for s3 bucket policy changes
resource "aws_cloudwatch_log_metric_filter" "s3_bucket_policy_change" {
  name           = format("%s-s3-bucket-policy-change", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }"

  metric_transformation {
    default_value = 0
    name          = format("%s-S3BucketPolicyChangeCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_policy_change" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-s3-bucket-policy-change", var.unique_prefix)
  alarm_description   = "Monitor s3 bucket policy changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-S3BucketPolicyChangeCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.9 Metric Filter/Alarm for AWS Config changes
resource "aws_cloudwatch_log_metric_filter" "aws_config_change" {
  name           = format("%s-aws-config-change", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ ($.eventSource = config.amazonaws.com) && (($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel) ||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder)) }"

  metric_transformation {
    name      = format("%s-AwsConfigChangeCount", var.unique_prefix)
    namespace = "CISBenchmark"
    value     = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "aws_config_change" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-aws-config-change", var.unique_prefix)
  alarm_description   = "Monitor for AWS Config changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-AwsConfigChangeCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.10 Metric Filter/Alarm for Security Group changes
resource "aws_cloudwatch_log_metric_filter" "security_group_change" {
  name           = format("%s-security-group-change", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }"

  metric_transformation {
    default_value = 0
    name          = format("%s-SecurityGroupChangeCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "security_group_change" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-security-group-change", var.unique_prefix)
  alarm_description   = "Monitor for security group changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-SecurityGroupChangeCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.11 Metric Filter/Alarm for NACL changes
resource "aws_cloudwatch_log_metric_filter" "nacl_change" {
  name           = format("%s-nacl-change", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"

  metric_transformation {
    default_value = 0
    name          = format("%s-NaclChangeCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "nacl_change" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-nacl-change", var.unique_prefix)
  alarm_description   = "Monitor for NACL changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-NaclChangeCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.12 Metric Filter/Alarm for network gateway changes
resource "aws_cloudwatch_log_metric_filter" "network_gateway_change" {
  name           = format("%s-network-gateway-change", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }"

  metric_transformation {
    default_value = 0
    name          = format("%s-NetworkGatewayChangeCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "network_gateway_change" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-network-gateway-change", var.unique_prefix)
  alarm_description   = "Monitor for network gateway changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-NetworkGatewayChangeCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.13 Metric Filter/Alarm for route table changes
resource "aws_cloudwatch_log_metric_filter" "route_table_change" {
  name           = format("%s-route-table-change", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }"

  metric_transformation {
    default_value = 0
    name          = format("%s-RouteTableChangeCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "route_table_change" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-route-table-change", var.unique_prefix)
  alarm_description   = "Monitor for route table changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-RouteTableChangeCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}

# CIS 3.14 Metric Filter/Alarm for VPC changes
resource "aws_cloudwatch_log_metric_filter" "vpc_change" {
  name           = format("%s-vpc-change", var.unique_prefix)
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }"

  metric_transformation {
    default_value = 0
    name          = format("%s-VpcChangeCount", var.unique_prefix)
    namespace     = "CISBenchmark"
    value         = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "vpc_change" {
  alarm_actions       = [format("arn:aws:sns:%s:%s:bedrock-security", data.aws_region.current.name, data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Security")])]
  alarm_name          = format("%s-vpc-change", var.unique_prefix)
  alarm_description   = "Monitor for VPC config changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = format("%s-VpcChangeCount", var.unique_prefix)
  namespace           = "CISBenchmark"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
}
