data "aws_ssoadmin_instances" "mgmt_sso" {
}

# Administrator Access
resource "aws_ssoadmin_permission_set" "administrator" {
  name         = "Administrator"
  description  = "Provides AdministratorAccess permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "administrator" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
}

# Billing Access
resource "aws_ssoadmin_permission_set" "billing" {
  name         = "Billing"
  description  = "Provides Billing permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "billing" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
  permission_set_arn = aws_ssoadmin_permission_set.billing.arn
}

# Read Only Access
resource "aws_ssoadmin_permission_set" "readonly" {
  name         = "ReadOnly"
  description  = "Provides Read Only permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "readonly" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}

# Security Admin Access
resource "aws_ssoadmin_permission_set" "security" {
  name         = "SecurityAdministrator"
  description  = "Provides Security Administrator permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "security" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSSecurityHubFullAccess"
  permission_set_arn = aws_ssoadmin_permission_set.security.arn
}

# Security ReadOnly
resource "aws_ssoadmin_permission_set" "security_ro" {
  name         = "SecurityReadOnly"
  description  = "Provides Security Read Only permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "security_ro" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  permission_set_arn = aws_ssoadmin_permission_set.security_ro.arn
}

# Terraform State Only
resource "aws_ssoadmin_permission_set" "terraformstate" {
  name             = "TerraformOrgState"
  description      = "Provides Terraform Development State permissions for CLI"
  instance_arn     = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  relay_state      = "https://s3.console.aws.amazon.com/s3/home?region=${data.aws_region.current.name}#"
  session_duration = "PT12H"
}

data "aws_iam_policy_document" "terraformstate" {
  statement {
    sid    = "AccessListS3"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      format("arn:aws:s3:::%s-tfstate", var.unique_prefix)
    ]
  }

  statement {
    sid = "AccessS3All"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    sid = "AccessS3"

    actions = [
      "s3:DeleteObject",
      "s3:GetEncryptionConfiguration",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      format("arn:aws:s3:::%s-tfstate/application/*", var.unique_prefix),
      format("arn:aws:s3:::%s-tfstate/%s/org", var.unique_prefix, var.bootstrap_prefix),
      format("arn:aws:s3:::%s-tfstate/fullstack", var.unique_prefix),
    ]
  }

  statement {
    sid    = "AccessDynamoDB"
    effect = "Allow"
    resources = [
      format("arn:aws:dynamodb:%s:%s:table/%s-tfstate", data.aws_region.current.name, data.aws_caller_identity.current.id, var.bootstrap_prefix)
    ]

    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
    ]
  }

  statement {
    sid       = "AssumeOpsOnly"
    effect    = "Allow"
    resources = [format("arn:aws:iam::*:role/%s", var.base_role)]
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "terraformstate" {
  inline_policy      = data.aws_iam_policy_document.terraformstate.json
  instance_arn       = aws_ssoadmin_permission_set.terraformstate.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraformstate.arn
}
