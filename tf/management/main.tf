module "modules_all_global" {
  source        = "../modules/global/foundation_baseline"
  alias_name    = local.workspace["env"]
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

module "management" {
  source        = "../modules/regional/foundation_baseline_management"
  base_region   = local.workspace["base_region"]
  notifications = local.workspace["notifications"]
  security      = local.workspace["security"]
  target_bucket = module.modules_all_regional.logging
  unique_prefix = local.workspace["unique_prefix"]

  aws_budgets = local.workspace["aws_budgets"]

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}


# Set the Alternate Contacts, Management Account will get a different address for Billing
resource "aws_account_alternate_contact" "altdetails" {
  for_each               = { for k in local.workspace["alt_contacts"] : k.Function => k if k.Function != "BILLING" }
  alternate_contact_type = each.value.Function == "finance" ? "BILLING" : each.value.Function # Management Account gets a different contact for Billing
  name                   = each.value.Name
  title                  = each.value.Title
  email_address          = each.value.Email
  phone_number           = each.value.Phone
}
