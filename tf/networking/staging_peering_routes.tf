#VPC Peering Public Routes
resource "aws_route" "staging_public_to_vpc_peering_rtb" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.staging
  for_each                  = toset(data.terraform_remote_state.staging.outputs.public_rt_ids)
  route_table_id            = each.value
  destination_cidr_block    = data.terraform_remote_state.central.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_staging.id
}

## Peering Private Routes
resource "aws_route" "staging_private_to_vpc_peering_rtbl" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.staging
  for_each                  = toset(data.terraform_remote_state.staging.outputs.private_rt_ids)
  route_table_id            = each.value
  destination_cidr_block    = data.terraform_remote_state.central.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_staging.id
}

#Peering SecureRoutes
resource "aws_route" "staging_secure_to_vpc_peering_rtb" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_staging
  ]
  provider                  = aws.staging
  for_each                  = toset(data.terraform_remote_state.staging.outputs.secure_rt_ids)
  route_table_id            = each.value
  destination_cidr_block    = data.terraform_remote_state.central.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_staging.id
}
