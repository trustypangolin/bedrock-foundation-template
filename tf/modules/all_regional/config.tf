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
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.bedrock]
}

resource "aws_config_configuration_aggregator" "bedrock" {
  count = var.security == data.aws_caller_identity.current.account_id ? 1 : 0
  name  = "default"
  account_aggregation_source {
    account_ids = var.aggregate
    regions     = [var.base_region]
  }
}

resource "aws_config_aggregate_authorization" "bedrock" {
  account_id = var.security
  region     = "ap-southeast-2"
}

resource "aws_config_configuration_recorder_status" "bedrock" {
  name       = aws_config_configuration_recorder.bedrock.name
  is_enabled = var.recorder
  depends_on = [aws_config_delivery_channel.bedrock]
}
