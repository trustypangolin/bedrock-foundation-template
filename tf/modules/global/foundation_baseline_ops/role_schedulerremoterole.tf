# Scheduler Remote Role. Scheduler Lambda in Central/Security will assume this role to schedule EC2/RDS
resource "aws_iam_role" "scheduler_role" {
  name               = "bedrock-SchedulerRemote"
  assume_role_policy = data.aws_iam_policy_document.scheduler.json
  inline_policy {
    name   = "OperationalScheduler"
    policy = data.aws_iam_policy_document.scheduler_perms.json
  }
}

data "aws_iam_policy_document" "scheduler" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    principals {
      type        = "AWS"
      identifiers = [var.central]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "scheduler_perms" {
  statement {
    actions = [
      "rds:DeleteDBSnapshot",
      "rds:DescribeDBSnapshots",
      "rds:StopDBInstance"
    ]
    resources = ["arn:aws:rds:*:*:snapshot:*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "rds:AddTagsToResource",
      "rds:RemoveTagsFromResource",
      "rds:DescribeDBSnapshots",
      "rds:StartDBInstance",
      "rds:StopDBInstance"
    ]
    resources = ["arn:aws:rds:*:*:db:*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "rds:AddTagsToResource",
      "rds:RemoveTagsFromResource",
      "rds:StartDBCluster",
      "rds:StopDBCluster"
    ]
    resources = ["arn:aws:rds:*:*:cluster:*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]
    resources = ["arn:aws:ec2:*:*:instance/*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:ModifyInstanceAttribute",
      "ssm:DescribeMaintenanceWindows",
      "ssm:DescribeMaintenanceWindowExecutions",
      "tag:GetResources"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "kms:CreateGrant"
    ]
    resources = [
      "arn:aws:kms:*:*:alias/aws/ebs",
      "arn:aws:kms:*:*:alias/aws/rds"
    ]
    effect = "Allow"
  }
}
