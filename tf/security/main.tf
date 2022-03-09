module "modules_all_global" {
  source        = "../modules/global/foundation_baseline"
  alias_name    = local.workspace["environment"]
  unique_prefix = local.workspace["unique_prefix"]
  security      = local.workspace["security"]
  central       = local.workspace["security"]
  grafana_id    = local.workspace["grafana_id"]
}

module "modules_all_regional" {
  source        = "../modules/regional/foundation_baseline"
  unique_prefix = local.workspace["unique_prefix"]
  base_region   = local.workspace["base_region"]
  security      = local.workspace["security"]
  aggregate     = data.terraform_remote_state.org.outputs.all_accounts_ids
  recorder      = false
  providers = {
    aws.ap-northeast-1 = aws.ap-northeast-1
    aws.ap-northeast-2 = aws.ap-northeast-2
    aws.ap-south-1     = aws.ap-south-1
    aws.ap-southeast-1 = aws.ap-southeast-1
    aws.ap-southeast-2 = aws.ap-southeast-2
    aws.eu-west-1      = aws.eu-west-1
    aws.ca-central-1   = aws.ca-central-1
    aws.eu-central-1   = aws.eu-central-1
    aws.eu-north-1     = aws.eu-north-1
    aws.eu-west-2      = aws.eu-west-2
    aws.eu-west-3      = aws.eu-west-3
    aws.sa-east-1      = aws.sa-east-1
    aws.us-east-1      = aws.us-east-1
    aws.us-east-2      = aws.us-east-2
    aws.us-west-1      = aws.us-west-1
    aws.us-west-2      = aws.us-west-2
  }
}

module "modules_security" {
  source        = "../modules/regional/foundation_baseline_security"
  unique_prefix = local.workspace["unique_prefix"]
  base_region   = local.workspace["base_region"]
  org_id        = local.workspace["org_id"]
  target_bucket = module.modules_all_regional.logging
  notifications = local.workspace["notifications"]
}

module "modules_lambda_tools" {
  source     = "../modules/regional/foundation_baseline_lambda"
  management  = local.workspace["management"]   # Which Account has the Org Account List
  operational = local.workspace["ops_accounts"] # List of Operational Accounts

  baseline_functions = {
    "DeleteDefaultVPC"    = true
    "InstanceScheduler"   = true
    "SnapshotSizeManager" = true
    "SnapshotTagManager"  = true
  }
}

# Set the Alternate Contacts
resource "aws_account_alternate_contact" "altdetails" {
  for_each               = { for k in local.workspace["alt_contacts"] : k.Function => k if k.Function != "finance" } # Filter out Management Account setting
  alternate_contact_type = each.value.Function
  name                   = each.value.Name
  title                  = each.value.Title
  email_address          = each.value.Email
  phone_number           = each.value.Phone
}
