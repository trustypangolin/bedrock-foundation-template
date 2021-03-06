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

module "module_vpn" {
  count         = var.enable_ec2_vpn == true ? 1 : 0
  source        = "../modules/regional/vpn/"
  unique_prefix = local.unique_prefix
  env           = var.env
  vpc_id        = module.modules_vpc.vpc.vpc_id
  subnet_id     = module.modules_vpc.vpc.public.subnet_ids[0]
}
