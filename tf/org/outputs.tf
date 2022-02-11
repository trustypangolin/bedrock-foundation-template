# This is how we get the account numbers and account names to all the other folders, 
# we export these, and pull it from the org state file directly, eg providers
output "acc" {
  value = merge({
    for k in data.aws_organizations_organization.org.accounts[*] :
    k.name => k.id
  })
}

# These are used mostly for the Management folder for SERVICE_CONTROL_POLICY,BACKUP_POLICY
# output "security" {
#   value = data.aws_organizations_organizational_units.org.children[0]
# }

# output "operational" {
#   value = data.aws_organizations_organizational_units.org.children[1]
# }

# output "org_id" {
#   value = data.aws_organizations_organization.org.id
# }

# output "org_root" {
#   value = data.aws_organizations_organization.org.roots[0]
# }

# output "ops_accounts" {
#   value = [for account in data.aws_organizations_organization.org.non_master_accounts: account.id if account.name != "Audit" && account.name != "Log Archive" ]
# }

output "all_accounts_ids" {
  value = [for account in data.aws_organizations_organization.org.accounts : account.id]
}
