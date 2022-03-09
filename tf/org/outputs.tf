# This is how we get the account numbers and account names to all the other folders, 
# we export these, and pull it from the org state file directly, eg providers
output "acc" {
  value = {
    for k in data.aws_organizations_organization.org.accounts[*] :
    k.name => k.id
  }
}

# Typically, AWS accounts don't always have nice consistant names, we map the real name to the functional lookup name.
output "acc_map" {
  value = local.workspace["acc_map"]
}

# Base Region for AWS
output "base_region" {
  value = local.workspace["base_region"]
}

# Role name used to assume child accounts wth Admin Privs
output "base_role" {
  value = local.workspace["base_role"]
}

# Customer Prefix
output "unique_prefix" {
  value = local.workspace["unique_prefix"]
}

# These are used mostly for the Management folder for SERVICE_CONTROL_POLICY,BACKUP_POLICY
output "security" {
  value = local.workspace["control_tower"] ? null : data.aws_organizations_organizational_units.org.children[0]
}

output "operational" {
  value = local.workspace["control_tower"] ? null : data.aws_organizations_organizational_units.org.children[1]
}

# Used for Cross Account Policies conditions
output "org_id" {
  value = data.aws_organizations_organization.org.id
}

output "org_root" {
  value = data.aws_organizations_organization.org.roots[0]
}

output "ops_accounts" {
  value = [for account in data.aws_organizations_organization.org.non_master_accounts : account.id if account.name != "Audit" && account.name != "Log Archive" && account.name != "Security"]
}

output "all_accounts_ids" {
  value = [for account in data.aws_organizations_organization.org.accounts : account.id]
}

# Observability - A good place to add in some common project variables
output "grafana_id" {
  value = local.workspace["grafana_id"]
}

# For Control Tower, we need a feature flag to let Control Tower manage its own resources
output "control_tower" {
  value = local.workspace["control_tower"]
}

output "notifications" {
  value = local.workspace["notifications"]
}

output "alt_contacts" {
  value = csvdecode(local.workspace["alt_contacts"])
}
