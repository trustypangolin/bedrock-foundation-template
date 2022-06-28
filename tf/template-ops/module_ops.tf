/* 
	This configuration includes following modules:
		AWS Config Rule
		AWS Backup Role
		Instance Scheduler Role
*/

module "modules_ops_global" {
  source  = "../modules/global/foundation_baseline_ops"
  central = local.security
}

module "modules_ops_regional" {
  source = "../modules/regional/foundation_baseline_ops"
}

module "modules_vpc" {
  source              = "../modules/regional/network/"
  network_prefix      = var.vpccidr
  env                 = var.env
  flow_log_bucket_arn = format("arn:aws:s3:::%s-flow-logs", local.unique_prefix)
}
