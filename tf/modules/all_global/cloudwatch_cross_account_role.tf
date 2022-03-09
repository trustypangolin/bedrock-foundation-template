data "aws_iam_policy_document" "cloudwatchassumepolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root", var.security)]
    }
  }
}

resource "aws_iam_role" "cw_role" {
  name = "CloudWatch-CrossAccountSharingRole"
  path = "/"
  managed_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
  "arn:aws:iam::aws:policy/CloudWatchAutomaticDashboardsAccess"]
  assume_role_policy = data.aws_iam_policy_document.cloudwatchassumepolicy.json
}

