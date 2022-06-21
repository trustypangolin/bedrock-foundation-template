resource "aws_flow_log" "flow_log_all" {
  count                = var.flow_log_bucket_arn == "" ? 0 : 1
  log_destination      = var.flow_log_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
  tags = {
    Name = format("%s-s3", var.env)
  }
}

### Flow log resources
resource "aws_flow_log" "flow_log_cw" {
  count                = var.create_log_group == true ? 1 : 0
  iam_role_arn         = aws_iam_role.log-group-role[0].arn
  log_destination      = aws_cloudwatch_log_group.log_group[0].arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
  tags = {
    Name = format("%s-cloudwatch-log-group", var.env)
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  count             = var.create_log_group == true ? 1 : 0
  name              = "/aws/vpc/flow-logs"
  retention_in_days = "3"
  tags = {
    Name = format("%s-flow-logs-log-group", var.env)
  }
}


resource "aws_iam_role" "log-group-role" {
  count              = var.create_log_group == true ? 1 : 0
  name               = format("bedrock-cloudwatch-vpc-%s", data.aws_region.current.name)
  assume_role_policy = data.aws_iam_policy_document.flow_logs.json
  inline_policy {
    name   = "vpc-cloudwatch-log-group-policy"
    policy = data.aws_iam_policy_document.log-group-policy.json
  }
}

data "aws_iam_policy_document" "flow_logs" {
  statement {
    sid = "AssumeFromFlowLogs"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "log-group-policy" {
  statement {
    sid = "FlowLogstoCWLG"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}
