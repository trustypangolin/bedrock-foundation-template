resource "aws_config_configuration_recorder" "bedrock" {
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "bedrock" {
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.bedrock]
}

resource "aws_config_configuration_aggregator" "bedrock" {
  count = var.security == data.aws_caller_identity.current.account_id ? 1 : 0
  name  = "default"
  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.config_org[0].arn
  }
}

resource "aws_iam_role" "config_org" {
  count                = var.security == data.aws_caller_identity.current.account_id ? 1 : 0
  name                 = "bedrock-config-aggregator-org"
  max_session_duration = 3600
  managed_policy_arns  = ["arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"]
  assume_role_policy   = data.aws_iam_policy_document.config_org[0].json
}

data "aws_iam_policy_document" "config_org" {
  count = var.security == data.aws_caller_identity.current.account_id ? 1 : 0
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}


resource "aws_config_aggregate_authorization" "base_region" {
  account_id = var.security
  region     = var.base_region
}

resource "aws_config_configuration_recorder_status" "bedrock" {
  name       = aws_config_configuration_recorder.bedrock.name
  is_enabled = var.recorder
  depends_on = [aws_config_delivery_channel.bedrock]
}
