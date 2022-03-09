locals {
  vpc_peering_connections = [
    {
        env                       = "prod"
        peer_account_id           = lookup(data.terraform_remote_state.org.outputs.acc, "Production")
        peer_vpc_id               = data.terraform_remote_state.prod.outputs.vpc_id
        peer_region               = var.aws_primary_region
        cidr_block                = data.terraform_remote_state.prod.outputs.vpc_cidr
    },
    {
        env                       = "staging"
        peer_account_id           = lookup(data.terraform_remote_state.org.outputs.acc, "Staging")
        peer_vpc_id               = data.terraform_remote_state.staging.outputs.vpc_id
        peer_region               = var.aws_primary_region
        cidr_block                = data.terraform_remote_state.staging.outputs.vpc_cidr
    },
    {
        env                       = "dev"
        peer_account_id           = lookup(data.terraform_remote_state.org.outputs.acc, "Development")
        peer_vpc_id               = data.terraform_remote_state.development.outputs.vpc_id
        peer_region               = var.aws_primary_region
        cidr_block                = data.terraform_remote_state.development.outputs.vpc_cidr
    }
  ]
}

module "modules_vpc_peering" {
  source                   = "../modules/vpc_peering"
  providers                = { 
    aws = aws.shared 
  }
  prefix                   =  var.customer_prefix
  tags                     =  var.tags
  enable_vpc_peering       = var.enable_vpc_peering 
  #vpc_peering_connections  = var.vpc_peering_connections
  vpc_peering_connections  = local.vpc_peering_connections
  aws_vpc_id               = data.terraform_remote_state.shared.outputs.vpc_id
}