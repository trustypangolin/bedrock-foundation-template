resource "aws_iam_role" "ecs_tools_task" {
  name               = format("%s_%s_tools_task_%s", var.env, var.cluster, data.aws_region.current.name)
  path               = "/ecs/"
  assume_role_policy = data.aws_iam_policy_document.ecstasks_trust.json
  inline_policy {
    name   = "AccessS3"
    policy = data.aws_iam_policy_document.s3.json
  }
  inline_policy {
    name   = "AccessECS"
    policy = data.aws_iam_policy_document.ecs.json
  }
  inline_policy {
    name   = "AccessR53"
    policy = data.aws_iam_policy_document.r53.json
  }
  inline_policy {
    name   = "AccessSSM"
    policy = data.aws_iam_policy_document.ssm.json
  }
  inline_policy {
    name   = "AccessECSExec"
    policy = data.aws_iam_policy_document.ecs-exec.json
  }
}

data "aws_iam_policy_document" "ecstasks_trust" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ecs" {
  statement {
    sid = "AccessECSProvider"
    actions = [
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTaskDefinition",
      "ec2:DescribeInstances",
      "ecs:ExecuteCommand"
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "r53" {
  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:route53:::hostedzone/*",
      "arn:aws:route53:::change/*",
    ]

    actions = [
      "route53:GetChange",
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["route53:ListHostedZonesByName"]
  }
}

data "aws_iam_policy_document" "ssm" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ssm:DescribeParameters"]
  }

  statement {
    effect    = "Allow"
    resources = [format("arn:aws:ssm:%s:%s:parameter/%s*", data.aws_region.current.name, data.aws_caller_identity.current.account_id, var.env)]
    actions   = ["ssm:GetParameters"]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "secretsmanager:GetSecretValue",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:secretsmanager:*:*:secret:*",
      "arn:aws:kms:*:*:key/*",
    ]
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid = "AccessS3"
    actions = [
      "s3:PutObject*",
      "s3:ListBucket",
      "s3:GetObject*",
      "s3:DeleteObject*",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload"
    ]
    resources = [
      "arn:aws:s3:::douugh-backup-*",
      "arn:aws:s3:::douugh-backup-*/*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ecs-exec" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["logs:DescribeLogGroups"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/ecs/ecs-exec-demo:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::douugh-tools-*/*"]
    actions   = ["s3:PutObject"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::douugh-tools-*"]
    actions   = ["s3:GetEncryptionConfiguration"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:Decrypt"]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_log_task" {
  role       = aws_iam_role.ecs_tools_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
