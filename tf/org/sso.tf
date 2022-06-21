data "aws_ssoadmin_instances" "mgmt_sso" {
}

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

resource "aws_ssoadmin_permission_set" "readonly" {
  name         = "ReadOnly"
  description  = "Provides Read Only permissions"
  instance_arn = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  # relay_state      = "https://s3.console.aws.amazon.com/s3/home?region={$data.aws_region.current}#"
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "readonly" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.mgmt_sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}

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
