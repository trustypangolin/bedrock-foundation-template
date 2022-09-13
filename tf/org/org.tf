locals {
  members = {
    # "Management" = data.aws_organizations_organization.org.roots[0].id
    "Security"   = data.aws_organizations_organizational_units.org.children[0].id
    "Central"    = data.aws_organizations_organizational_units.org.children[1].id
    "Production" = data.aws_organizations_organizational_units.org.children[1].id
    # "Development" = data.aws_organizations_organizational_units.org.children[1].id
  }
}

# terraform import aws_organizations_organization.org r-abcde
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = sort(compact([
    local.workspace["control_tower"] ? "controltower.amazonaws.com" : null,             # Only Enable if it's already active
    local.workspace["control_tower"] ? null : "config-multiaccountsetup.amazonaws.com", # Only Enable if Control Tower isn't active
    "access-analyzer.amazonaws.com",
    "account.amazonaws.com",
    "auditmanager.amazonaws.com",
    "aws-artifact-account-sync.amazonaws.com",
    "backup.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "compute-optimizer.amazonaws.com",
    "config.amazonaws.com",
    "fms.amazonaws.com",
    "guardduty.amazonaws.com",
    "health.amazonaws.com",
    "inspector2.amazonaws.com",
    "license-management.marketplace.amazonaws.com",
    "license-manager.amazonaws.com",
    "license-manager.member-account.amazonaws.com",
    "macie.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "ram.amazonaws.com",
    "reporting.trustedadvisor.amazonaws.com",
    "securityhub.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "servicequotas.amazonaws.com",
    "ssm.amazonaws.com",
    "sso.amazonaws.com",
    "storage-lens.s3.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
  ]))
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "BACKUP_POLICY",
    "TAG_POLICY"
  ]
  feature_set = "ALL"
}

data "aws_organizations_organization" "org" {
  depends_on = [aws_organizations_organization.org]
}

data "aws_organizations_organizational_units" "org" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

# terraform import aws_organizations_organizational_unit.security ou-abcd-123efg456
resource "aws_organizations_organizational_unit" "security" {
  count     = local.workspace["control_tower"] ? 0 : 1
  name      = "Security"
  parent_id = aws_organizations_organization.org.roots[0].id
  tags      = var.tags
}

# terraform import aws_organizations_organizational_unit.operational ou-abcd-234efg789
resource "aws_organizations_organizational_unit" "operational" {
  count     = local.workspace["control_tower"] ? 0 : 1
  name      = "Operational"
  parent_id = aws_organizations_organization.org.roots[0].id
  tags      = var.tags
}

# For precreated accounts, import the following resources first
# terraform import 'aws_organizations_account.members["Development"]' 111222333444

# For Control Tower, Terraform isn't used to create the accounts
resource "aws_organizations_account" "members" {
  for_each  = local.workspace["control_tower"] ? {} : local.workspace["root_emails"]
  name      = lookup(local.workspace.acc_map, each.key)
  email     = each.value
  parent_id = lookup(local.members, each.key)
  role_name = local.workspace.base_role
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [role_name]
  }
}
