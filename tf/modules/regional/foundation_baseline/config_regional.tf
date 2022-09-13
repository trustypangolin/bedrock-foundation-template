resource "aws_config_aggregate_authorization" "eu-north-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.eu-north-1
  account_id = var.security
  region     = "eu-north-1"
}

resource "aws_config_configuration_recorder" "eu-north-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.eu-north-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "eu-north-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "eu-north-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.eu-north-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "eu-north-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.eu-north-1[0]]
}

resource "aws_config_aggregate_authorization" "ap-south-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.ap-south-1
  account_id = var.security
  region     = "ap-south-1"
}

resource "aws_config_configuration_recorder" "ap-south-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.ap-south-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "ap-south-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "ap-south-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.ap-south-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "ap-south-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.ap-south-1[0]]
}

resource "aws_config_aggregate_authorization" "eu-west-3" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.eu-west-3
  account_id = var.security
  region     = "eu-west-3"
}

resource "aws_config_configuration_recorder" "eu-west-3" {
  count    = var.control_tower ? 0 : 1
  provider = aws.eu-west-3
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "eu-west-3" ? true : false
  }
}

resource "aws_config_delivery_channel" "eu-west-3" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.eu-west-3
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "eu-west-3", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.eu-west-3[0]]
}

resource "aws_config_aggregate_authorization" "eu-west-2" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.eu-west-2
  account_id = var.security
  region     = "eu-west-2"
}

resource "aws_config_configuration_recorder" "eu-west-2" {
  count    = var.control_tower ? 0 : 1
  provider = aws.eu-west-2
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "eu-west-2" ? true : false
  }
}

resource "aws_config_delivery_channel" "eu-west-2" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.eu-west-2
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "eu-west-2", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.eu-west-2[0]]
}

resource "aws_config_aggregate_authorization" "eu-west-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.eu-west-1
  account_id = var.security
  region     = "eu-west-1"
}

resource "aws_config_configuration_recorder" "eu-west-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.eu-west-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "eu-west-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "eu-west-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.eu-west-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "eu-west-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.eu-west-1[0]]
}

resource "aws_config_aggregate_authorization" "ap-northeast-2" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.ap-northeast-2
  account_id = var.security
  region     = "ap-northeast-2"
}

resource "aws_config_configuration_recorder" "ap-northeast-2" {
  count    = var.control_tower ? 0 : 1
  provider = aws.ap-northeast-2
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "ap-northeast-2" ? true : false
  }
}

resource "aws_config_delivery_channel" "ap-northeast-2" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.ap-northeast-2
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "ap-northeast-2", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.ap-northeast-2[0]]
}

resource "aws_config_aggregate_authorization" "ap-northeast-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.ap-northeast-1
  account_id = var.security
  region     = "ap-northeast-1"
}

resource "aws_config_configuration_recorder" "ap-northeast-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.ap-northeast-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "ap-northeast-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "ap-northeast-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.ap-northeast-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "ap-northeast-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.ap-northeast-1[0]]
}

resource "aws_config_aggregate_authorization" "sa-east-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.sa-east-1
  account_id = var.security
  region     = "sa-east-1"
}

resource "aws_config_configuration_recorder" "sa-east-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.sa-east-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "sa-east-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "sa-east-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.sa-east-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "sa-east-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.sa-east-1[0]]
}

resource "aws_config_aggregate_authorization" "ca-central-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.ca-central-1
  account_id = var.security
  region     = "ca-central-1"
}

resource "aws_config_configuration_recorder" "ca-central-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.ca-central-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "ca-central-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "ca-central-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.ca-central-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "ca-central-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.ca-central-1[0]]
}

resource "aws_config_aggregate_authorization" "ap-southeast-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.ap-southeast-1
  account_id = var.security
  region     = "ap-southeast-1"
}

resource "aws_config_configuration_recorder" "ap-southeast-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.ap-southeast-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "ap-southeast-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "ap-southeast-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.ap-southeast-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "ap-southeast-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.ap-southeast-1[0]]
}

resource "aws_config_aggregate_authorization" "ap-southeast-2" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.ap-southeast-2
  account_id = var.security
  region     = "ap-southeast-2"
}

resource "aws_config_configuration_recorder" "ap-southeast-2" {
  count    = var.control_tower ? 0 : 1
  provider = aws.ap-southeast-2
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "ap-southeast-2" ? true : false
  }
}

resource "aws_config_delivery_channel" "ap-southeast-2" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.ap-southeast-2
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "ap-southeast-2", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.ap-southeast-2[0]]
}

resource "aws_config_aggregate_authorization" "eu-central-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.eu-central-1
  account_id = var.security
  region     = "eu-central-1"
}

resource "aws_config_configuration_recorder" "eu-central-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.eu-central-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "eu-central-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "eu-central-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.eu-central-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "eu-central-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.eu-central-1[0]]
}

resource "aws_config_aggregate_authorization" "us-east-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.us-east-1
  account_id = var.security
  region     = "us-east-1"
}

resource "aws_config_configuration_recorder" "us-east-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.us-east-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "us-east-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "us-east-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.us-east-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "us-east-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.us-east-1[0]]
}

resource "aws_config_aggregate_authorization" "us-east-2" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.us-east-2
  account_id = var.security
  region     = "us-east-2"
}

resource "aws_config_configuration_recorder" "us-east-2" {
  count    = var.control_tower ? 0 : 1
  provider = aws.us-east-2
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "us-east-2" ? true : false
  }
}

resource "aws_config_delivery_channel" "us-east-2" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.us-east-2
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "us-east-2", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.us-east-2[0]]
}

resource "aws_config_aggregate_authorization" "us-west-1" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.us-west-1
  account_id = var.security
  region     = "us-west-1"
}

resource "aws_config_configuration_recorder" "us-west-1" {
  count    = var.control_tower ? 0 : 1
  provider = aws.us-west-1
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "us-west-1" ? true : false
  }
}

resource "aws_config_delivery_channel" "us-west-1" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.us-west-1
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "us-west-1", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.us-west-1[0]]
}

resource "aws_config_aggregate_authorization" "us-west-2" {
  count      = var.control_tower ? 0 : 1
  provider   = aws.us-west-2
  account_id = var.security
  region     = "us-west-2"
}

resource "aws_config_configuration_recorder" "us-west-2" {
  count    = var.control_tower ? 0 : 1
  provider = aws.us-west-2
  name     = "default"
  role_arn = format("arn:aws:iam::%s:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig", data.aws_caller_identity.current.account_id)
  recording_group {
    all_supported                 = true
    include_global_resource_types = var.base_region == "us-west-2" ? true : false
  }
}

resource "aws_config_delivery_channel" "us-west-2" {
  count          = var.control_tower ? 0 : 1
  provider       = aws.us-west-2
  name           = "default"
  s3_bucket_name = format("%s-config-recordings", var.unique_prefix)
  sns_topic_arn  = var.sns_topic == null ? null : format("arn:aws:sns:%s:%s:%s", "us-west-2", data.aws_caller_identity.current.account_id, var.sns_topic)
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.us-west-2[0]]
}

