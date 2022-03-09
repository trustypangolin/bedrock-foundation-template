resource "aws_flow_log" "flow_log_all" {
  count                = var.flow_log_bucket_arn == "" ? 0 : 1
  log_destination      = var.flow_log_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
}

### Flow log resources
resource "aws_flow_log" "flow_log_cw" {
  iam_role_arn         = aws_iam_role.log-group-role.arn
  log_destination      = aws_cloudwatch_log_group.log_group.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = "3"
  tags = {
    Name = "${var.env}-flow-logs-log-group"
  }

}


resource "aws_iam_role" "log-group-role" {
  # count = var.create_log_group_iam_role == true ? 1 : 0
  name = "${var.env}-cloudwatch-log-group-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "log-group-policy" {
  # count  = var.create_log_group_iam_role == true ? 1 : 0
  name   = "${var.env}-cloudwatch-log-group-policy"
  role   = aws_iam_role.log-group-role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
