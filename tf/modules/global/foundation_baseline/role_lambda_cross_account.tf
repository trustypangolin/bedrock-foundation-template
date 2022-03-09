# Allow designated Central (or Security) Account Access to this role and perform actions with Lambda 
resource "aws_iam_role" "lambda_childmgmt" {
  count               = var.lambda_crossaccount_role == true ? 1 : 0
  name                = var.crossaccountrole
  assume_role_policy  = data.aws_iam_policy_document.child_mgmt.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name   = "SQSAccess"
    policy = data.aws_iam_policy_document.publish_sqs.json
  }
  inline_policy {
    name   = "EC2TagManager"
    policy = data.aws_iam_policy_document.ec2tagmanager.json
  }
  inline_policy {
    name   = "VPCDefaultResourceManager"
    policy = data.aws_iam_policy_document.removerules.json
  }
  inline_policy {
    name   = "VPCDeleteResourceseManager"
    policy = data.aws_iam_policy_document.deldefvpc.json
  }
  inline_policy {
    name   = "SnapshotSizeManager"
    policy = data.aws_iam_policy_document.snapshotsize.json
  }
  inline_policy {
    name   = "KMSAccess"
    policy = data.aws_iam_policy_document.kms.json
  }
  inline_policy {
    name   = "IAMAccess"
    policy = data.aws_iam_policy_document.iamkeys.json
  }

  # Only useful for Management Account to list accounts in the OU
  inline_policy {
    name   = "OrgListAccess"
    policy = data.aws_iam_policy_document.orglistacc.json
  }

}

data "aws_iam_policy_document" "child_mgmt" {
  statement {
    sid = "AssumeFromCentral"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root", var.central)]
    }
  }
}

data "aws_iam_policy_document" "publish_sns" {
  statement {
    sid = "defaultstatementID"
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]
    resources = [
      "arn:aws:sns:*:*:bedrock*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "publish_sqs" {
  statement {
    sid = "defaultstatementID"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:ChangeMessageVisibility"
    ]
    resources = [
      "arn:aws:sqs:*:*:bedrock*",
      "arn:aws:sqs:*:*:bedrock*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ec2tagmanager" {
  statement {
    sid = "ec2tagmanager"
    actions = [
      "ec2:Describe*",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "tags:GetResources"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "snapshotsize" {
  statement {
    sid = "ec2tagmanager"
    actions = [
      "ec2:Describe*",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "tags:GetResources"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }

  statement {
    sid = "BlockDifference"
    actions = [
      "ebs:ListChangedBlocks"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "removerules" {
  statement {
    sid = "ec2tagmanager"
    actions = [
      "ec2:Describe*",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:CreateTags",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DeleteRoute",
      "ec2:DeleteNetworkAclEntry"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "deldefvpc" {
  statement {
    sid = "deleteec2resource"
    actions = [
      "ec2:DescribeInternetGateways",
      "ec2:DeleteSubnet",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRegions",
      "ec2:DescribeAccountAttributes",
      "ec2:DeleteVpc",
      "ec2:DetachInternetGateway",
      "ec2:DescribeSubnets",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }

  statement {
    sid = "deletedefaultvpc"
    actions = [
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteNetworkAcl",
      "ec2:DeleteRouteTable"
    ]
    resources = [
      "arn:aws:ec2:*:*:route-table/*",
      "arn:aws:ec2:*:*:security-group/*",
      "arn:aws:ec2:*:*:network-acl/*",
      "arn:aws:ec2:*:*:internet-gateway/*"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid = "lambdakms"
    actions = [
      "kms:*"
    ]
    resources = [
      "arn:aws:kms:*:*:alias/aws/lambda",
      "arn:aws:kms:*:*:alias/aws/ebs",
      "arn:aws:kms:*:*:alias/aws/rds"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "iamkeys" {
  statement {
    sid    = "allowiam"
    effect = "Allow"
    actions = [
      "iam:ListUsers",
      "iam:ListGroupsForUser",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "orglistacc" {
  statement {
    sid    = "alloworglist"
    effect = "Allow"
    actions = [
      "organizations:ListAccounts",
      "organizations:ListAccountsForParent",
      "organizations:DescribeOrganization",
    ]
    resources = [
      "*"
    ]
  }
}
