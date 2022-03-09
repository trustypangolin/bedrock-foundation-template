data "aws_iam_policy_document" "instanceassumepolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions = ["ssm:DescribeAssociation",
      "ssm:GetDocument",
      "ssm:ListAssociations",
      "ssm:UpdateAssociationStatus",
    "ssm:UpdateInstanceInformation"]
    resources = ["*"]
  }
  statement {
    actions = ["ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
    "ec2messages:SendReply"]
    resources = ["*"]
  }
  statement {
    actions   = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }
  statement {
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
  statement {
    actions = ["logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    "logs:PutLogEvents"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "role" {
  name = "bedrock-EC2-defaultSSMandCW-Role"
  path = "/"
  managed_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  assume_role_policy = data.aws_iam_policy_document.instanceassumepolicy.json
  inline_policy {
    name   = "policy-ec2"
    policy = data.aws_iam_policy_document.inline_policy.json
  }
}

resource "aws_iam_instance_profile" "profile" {
  name = "bedrock-EC2-defaultSSMandCW-Profile"
  role = aws_iam_role.role.name
}
