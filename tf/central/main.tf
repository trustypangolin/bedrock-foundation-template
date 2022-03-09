module "modules_all_global" {
  count         = local.base_region == local.region ? 1 : 0
  source        = "../modules/global/foundation_baseline"
  alias_name    = local.workspace["environment"]
  unique_prefix = local.workspace["unique_prefix"]
  security      = local.workspace["security"]
  central       = local.workspace["security"]
  grafana_id    = local.workspace["grafana_id"]
}

module "modules_all_regional" {
  count         = local.base_region == local.region ? 1 : 0
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

module "modules_ops_global" {
  count   = local.base_region == local.region ? 1 : 0
  source  = "../modules/global/foundation_baseline_ops"
  central = local.workspace["security"]
}

module "modules_ops_regional" {
  source = "../modules/regional/foundation_baseline_ops"
}

module "modules_vpc" {
  source              = "../modules/regional/network/"
  network_prefix      = local.workspace["vpccidr"]
  env                 = local.workspace["environment"]
  number_of_ngws      = local.workspace["number_of_ngws"]
  flow_log_bucket_arn = format("arn:aws:s3:::%s-flow-logs", local.workspace["unique_prefix"])
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

module "module_vpn" {
  count         = local.workspace.solution_ec2_vpc ? 1 : 0
  source        = "../modules/regional/solutions/ec2_vpn/"
  unique_prefix = local.unique_prefix
  env           = local.environment
  vpc_id        = module.modules_vpc.vpc.vpc_id
  subnet_id     = module.modules_vpc.vpc.public.subnet_ids[0]
}

module "solution_cloudfront_s3" {
  count         = local.workspace.solution_cloudfront_s3 ? 1 : 0
  source        = "../modules/regional/solutions/cloudfront_s3"
  unique_prefix = local.unique_prefix
}
