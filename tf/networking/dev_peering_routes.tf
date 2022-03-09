#VPC Peering Public Routes
resource "aws_route" "dev_public_to_vpc_peering_rtb" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_dev
  ]
  provider                  = aws.dev
  for_each                  = toset(data.terraform_remote_state.development.outputs.public_rt_ids)
  route_table_id            = each.value
  destination_cidr_block    = data.terraform_remote_state.shared.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_dev.id
}

## Peering Private Routes
resource "aws_route" "dev_private_to_vpc_peering_rtbl" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_dev
  ]
  provider                  = aws.dev
  for_each                  = toset(data.terraform_remote_state.development.outputs.private_rt_ids)
  route_table_id            = each.value
  destination_cidr_block    = data.terraform_remote_state.shared.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_dev.id
}

#Peering SecureRoutes
resource "aws_route" "dev_secure_to_vpc_peering_rtb" {
  depends_on = [
    module.modules_vpc_peering,
    aws_vpc_peering_connection_accepter.peer_dev
  ]
  provider                  = aws.dev
  for_each                  = toset(data.terraform_remote_state.development.outputs.secure_rt_ids)
  route_table_id            = each.value
  destination_cidr_block    = data.terraform_remote_state.shared.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_dev.id
}
