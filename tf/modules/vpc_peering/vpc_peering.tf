#Peering connection between shared account to operational accounts
resource "aws_vpc_peering_connection" "vpc_peering" {
  count         = var.enable_vpc_peering == true && length(var.vpc_peering_connections) > 0 ? length(var.vpc_peering_connections) : 0
  peer_owner_id = var.vpc_peering_connections[count.index].peer_account_id
  peer_vpc_id   = var.vpc_peering_connections[count.index].peer_vpc_id
  peer_region   = var.vpc_peering_connections[count.index].peer_region
  vpc_id        = var.aws_vpc_id
  #If set to true, it doesn't accept peer_region parameter
  auto_accept   = false
  tags = merge(
    {
    Name = "${var.prefix}-shared-to-${var.vpc_peering_connections[count.index].env}-pcx"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [accept_status]
  }
}
