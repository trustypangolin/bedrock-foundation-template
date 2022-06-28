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

# Database Administrator Access
resource "aws_ssoadmin_permission_set" "dba" {
  name         = "DBAAdministrator"
  description  = "Provides Database Administrator permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "dba" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
  permission_set_arn = aws_ssoadmin_permission_set.dba.arn
}

# Power Ussr/Developer Access
resource "aws_ssoadmin_permission_set" "developer" {
  name         = "Developer"
  description  = "Provides PowerUserAccess permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "developer" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn
}

# Network Administrator Access
resource "aws_ssoadmin_permission_set" "network" {
  name         = "NetworkAdministrator"
  description  = "Provides Network Administrator permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "network" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
  permission_set_arn = aws_ssoadmin_permission_set.network.arn
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

# System Administrator Access
resource "aws_ssoadmin_permission_set" "sysadmin" {
  name         = "SystemAdministrator"
  description  = "Provides System Administrator permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "sysadmin" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
  permission_set_arn = aws_ssoadmin_permission_set.sysadmin.arn
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
  name             = "TerraformDevState"
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
      aws_s3_bucket.tfstate.arn
    ]
  }

  statement {
    sid = "AccessS3All"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    sid = "AccessS3"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetEncryptionConfiguration"
    ]

    resources = [
      format("%s/application/*", aws_s3_bucket.tfstate.arn),
      format("%s/bedrock/org", aws_s3_bucket.tfstate.arn),
      format("%s/fullstack", aws_s3_bucket.tfstate.arn),
    ]
  }

  statement {
    sid    = "AccessDynamoDB"
    effect = "Allow"
    resources = [
      aws_dynamodb_table.terraform.arn
    ]

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
  }

  statement {
    sid       = "AssumeOpsOnly"
    effect    = "Allow"
    resources = [format("arn:aws:iam::%s:role/bedrock-terraform", aws_organizations_account.members["Production"].id)]
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
