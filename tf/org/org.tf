# locals {
#   members = {
#     "Management" = data.aws_organizations_organization.org.roots[0].id
#     # "Management"  = data.aws_organizations_organizational_units.org.children[2].id
#     "Log Archive" = data.aws_organizations_organizational_units.org.children[0].id
#     "Audit"       = data.aws_organizations_organizational_units.org.children[0].id
#     "Shared"      = data.aws_organizations_organizational_units.org.children[1].id
#     "Production"  = data.aws_organizations_organizational_units.org.children[1].id
#     "Staging"     = data.aws_organizations_organizational_units.org.children[1].id
#     "Development" = data.aws_organizations_organizational_units.org.children[1].id
#   }
# }

# terraform import aws_organizations_organization.org r-abcde
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "compute-optimizer.amazonaws.com",
    "config.amazonaws.com",
    # "controltower.amazonaws.com",
    "guardduty.amazonaws.com",
    "health.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "securityhub.amazonaws.com",
    "sso.amazonaws.com",
    "backup.amazonaws.com",
  ]
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "BACKUP_POLICY"
  ]
}

data "aws_organizations_organization" "org" {
  depends_on = [aws_organizations_organization.org]
}

data "aws_organizations_organizational_units" "org" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

# # terraform import aws_organizations_organizational_unit.security ou-abcd-123efg456
# resource "aws_organizations_organizational_unit" "security" {
#   name      = "Security"
#   parent_id = aws_organizations_organization.org.roots[0].id
#   tags      = merge(var.common_tags, var.tags)
# }

# # terraform import aws_organizations_organizational_unit.operational ou-abcd-234efg789
# resource "aws_organizations_organizational_unit" "operational" {
#   name      = "Operational"
#   parent_id = aws_organizations_organization.org.roots[0].id
#   tags      = merge(var.common_tags, var.tags)
# }

# resource "aws_organizations_organizational_unit" "billing" {
#   name      = "Billing"
#   parent_id = aws_organizations_organization.org.roots[0].id
#   tags      = merge(var.common_tags, var.tags)
# }

# # For precreated accounts, import the following resources first
# # terraform import aws_organizations_account.members[\"Management\"] 111222333444

# # For Control Tower, import the following resources first
# # terraform import aws_organizations_account.members[\"Log\ Archive\"] 333444555666
# # terraform import aws_organizations_account.members[\"Audit\"] 222333444555
# resource "aws_organizations_account" "members" {
#   for_each  = var.root_emails
#   name      = each.key
#   email     = each.value
#   parent_id = lookup(local.members, each.key)
#   role_name = "Foundation-Terraform"
#   lifecycle {
#     prevent_destroy = true
#     ignore_changes  = [role_name]
#   }
# }
