# Prod Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer_prod" {
  depends_on                = [module.modules_vpc_peering]
  provider                  = aws.prod
  vpc_peering_connection_id = module.modules_vpc_peering.vpc_peering_connectionpeering_peer_ids[0]
  auto_accept               = true
  tags = merge({Side = "Accepter"}, var.common_tags, var.tags)
}

# Staging Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer_staging" {
  depends_on                = [module.modules_vpc_peering]
  provider                  = aws.staging
  vpc_peering_connection_id = module.modules_vpc_peering.vpc_peering_connectionpeering_peer_ids[1]
  auto_accept               = true
  tags = merge({Side = "Accepter"}, var.common_tags, var.tags)
}

# Dev Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer_dev" {
  depends_on                = [module.modules_vpc_peering]
  provider                  = aws.dev
  vpc_peering_connection_id = module.modules_vpc_peering.vpc_peering_connectionpeering_peer_ids[2]
  auto_accept               = true
  tags = merge({Side = "Accepter"}, var.common_tags, var.tags)
}