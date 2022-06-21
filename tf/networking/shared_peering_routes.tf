locals {
  vpc_peering_routes = [
    {
      env             = "prod"
      peer_account_id = data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Production")]
      peer_vpc_id     = data.terraform_remote_state.prod.outputs.vpc_id
      peer_region     = var.aws_primary_region
      cidr_block      = data.terraform_remote_state.prod.outputs.vpc_cidr
      pcx-id          = length(module.modules_vpc_peering.vpc_peering_connectionpeering_peer_ids[0]) > 0 ? module.modules_vpc_peering.vpc_peering_connectionpeering_peer_ids[0] : null
    },
    {
      env             = "staging"
      peer_account_id = lookup(data.terraform_remote_state.org.outputs.acc, "Staging")
      peer_vpc_id     = data.terraform_remote_state.staging.outputs.vpc_id
      peer_region     = var.aws_primary_region
      cidr_block      = data.terraform_remote_state.staging.outputs.vpc_cidr
      pcx-id          = length(module.modules_vpc_peering.vpc_peering_connectionpeering_peer_ids[1]) > 0 ? module.modules_vpc_peering.vpc_peering_connectionpeering_peer_ids[1] : null
    },
    {
      env             = "dev"
      peer_account_id = lookup(data.terraform_remote_state.org.outputs.acc, "Development")
      peer_vpc_id     = data.terraform_remote_state.development.outputs.vpc_id
      peer_region     = var.aws_primary_region
      cidr_block      = data.terraform_remote_state.development.outputs.vpc_cidr
      pcx-id          = length(module.modules_vpc_peering.vpc_peering_connectionpeering_peer_ids[2]) > 0 ? module.modules_vpc_peering.vpc_peering_connectionpeering_peer_ids[2] : null
    }
  ]
}

#VPC Peering Public Routes
resource "aws_route" "central_public_to_vpc_peering_rtb0" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_prod,
    aws_vpc_peering_connection_accepter.peer_dev,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.central
  count                     = length(local.vpc_peering_routes) > 0 ? length(local.vpc_peering_routes) : 0
  route_table_id            = data.terraform_remote_state.central.outputs.public_rt_ids[0]
  destination_cidr_block    = local.vpc_peering_routes[count.index].cidr_block
  vpc_peering_connection_id = local.vpc_peering_routes[count.index].pcx-id
}

resource "aws_route" "central_public_to_vpc_peering_rtbl1" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_prod,
    aws_vpc_peering_connection_accepter.peer_dev,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.central
  count                     = length(local.vpc_peering_routes) > 0 ? length(local.vpc_peering_routes) : 0
  route_table_id            = data.terraform_remote_state.central.outputs.public_rt_ids[1]
  destination_cidr_block    = local.vpc_peering_routes[count.index].cidr_block
  vpc_peering_connection_id = local.vpc_peering_routes[count.index].pcx-id
}

resource "aws_route" "central_public_to_vpc_peering_rtbl2" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_prod,
    aws_vpc_peering_connection_accepter.peer_dev,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.central
  count                     = length(local.vpc_peering_routes) > 0 ? length(local.vpc_peering_routes) : 0
  route_table_id            = data.terraform_remote_state.central.outputs.public_rt_ids[2]
  destination_cidr_block    = local.vpc_peering_routes[count.index].cidr_block
  vpc_peering_connection_id = local.vpc_peering_routes[count.index].pcx-id
}

## Peering Private Routes
resource "aws_route" "central_private_to_vpc_peering_rtbl0" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_prod,
    aws_vpc_peering_connection_accepter.peer_dev,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.central
  count                     = length(local.vpc_peering_routes) > 0 ? length(local.vpc_peering_routes) : 0
  route_table_id            = data.terraform_remote_state.central.outputs.private_rt_ids[0]
  destination_cidr_block    = local.vpc_peering_routes[count.index].cidr_block
  vpc_peering_connection_id = local.vpc_peering_routes[count.index].pcx-id
}

resource "aws_route" "central_private_to_vpc_peering_rtbl1" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_prod,
    aws_vpc_peering_connection_accepter.peer_dev,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.central
  count                     = length(local.vpc_peering_routes) > 0 ? length(local.vpc_peering_routes) : 0
  route_table_id            = data.terraform_remote_state.central.outputs.private_rt_ids[1]
  destination_cidr_block    = local.vpc_peering_routes[count.index].cidr_block
  vpc_peering_connection_id = local.vpc_peering_routes[count.index].pcx-id
}

resource "aws_route" "central_private_to_vpc_peering_rtbl2" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_prod,
    aws_vpc_peering_connection_accepter.peer_dev,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.central
  count                     = length(local.vpc_peering_routes) > 0 ? length(local.vpc_peering_routes) : 0
  route_table_id            = data.terraform_remote_state.central.outputs.private_rt_ids[2]
  destination_cidr_block    = local.vpc_peering_routes[count.index].cidr_block
  vpc_peering_connection_id = local.vpc_peering_routes[count.index].pcx-id
}
#Peering SecureRoutes
resource "aws_route" "central_secure_to_vpc_peering_rtb0" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_prod,
    aws_vpc_peering_connection_accepter.peer_dev,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.central
  count                     = length(local.vpc_peering_routes) > 0 ? length(local.vpc_peering_routes) : 0
  route_table_id            = data.terraform_remote_state.central.outputs.secure_rt_ids[0]
  destination_cidr_block    = local.vpc_peering_routes[count.index].cidr_block
  vpc_peering_connection_id = local.vpc_peering_routes[count.index].pcx-id
}

resource "aws_route" "central_secure_to_vpc_peering_rtbl1" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_prod,
    aws_vpc_peering_connection_accepter.peer_dev,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.central
  count                     = length(local.vpc_peering_routes) > 0 ? length(local.vpc_peering_routes) : 0
  route_table_id            = data.terraform_remote_state.central.outputs.secure_rt_ids[1]
  destination_cidr_block    = local.vpc_peering_routes[count.index].cidr_block
  vpc_peering_connection_id = local.vpc_peering_routes[count.index].pcx-id
}

resource "aws_route" "central_secure_to_vpc_peering_rtbl2" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_prod,
    aws_vpc_peering_connection_accepter.peer_dev,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.central
  count                     = length(local.vpc_peering_routes) > 0 ? length(local.vpc_peering_routes) : 0
  route_table_id            = data.terraform_remote_state.central.outputs.secure_rt_ids[2]
  destination_cidr_block    = local.vpc_peering_routes[count.index].cidr_block
  vpc_peering_connection_id = local.vpc_peering_routes[count.index].pcx-id
}
