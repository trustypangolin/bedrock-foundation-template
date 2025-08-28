
module "modules_all_global" {
  source        = "../modules/global/foundation_baseline"
  alias_name    = "template"
  unique_prefix = local.unique_prefix
  security      = local.security
  central       = local.security
  grafana_id    = var.grafana_id
}

module "modules_all_regional" {
  source        = "../modules/regional/foundation_baseline"
  unique_prefix = local.unique_prefix
  base_region   = local.base_region
  security      = local.security
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
