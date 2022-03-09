/* 
	This configuration includes following modules:
		AWS Config Rule
		AWS Backup Role
		Instance Scheduler Role
*/

module "modules_ops_global" {
  source  = "../modules/ops_global/"
  central = lookup(data.terraform_remote_state.org.outputs.acc, "Security")
}

module "modules_ops_regional" {
  source = "../modules/ops_regional/"
}

module "modules_vpc" {
  source              = "../modules/network/"
  network_prefix      = var.vpccidr
  env                 = var.unique_prefix
  flow_log_bucket_arn = format("arn:aws:s3:::%s-flow-logs", var.unique_prefix)
}
