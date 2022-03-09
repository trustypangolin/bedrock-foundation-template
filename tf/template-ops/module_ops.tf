/* 
	This configuration includes following modules:
		AWS Config Rule
		AWS Backup Role
		Instance Scheduler Role
*/

module "modules_ops_global" {
  source = "../modules/ops_global/"
  # unique_prefix = var.unique_prefix
}

module "modules_ops_regional" {
  source = "../modules/ops_regional/"
  # unique_prefix = var.unique_prefix
}
