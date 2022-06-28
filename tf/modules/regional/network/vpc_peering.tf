# #Peering connection between central account to operational accounts
# resource "aws_vpc_peering_connection" "vpc_peering" {
#   count         = var.enable_vpc_peering == true && length(var.vpc_peering_connections) > 0 ? length(var.vpc_peering_connections) : 0
#   peer_owner_id = var.vpc_peering_connections[count.index].peer_account_id
#   peer_vpc_id   = var.vpc_peering_connections[count.index].peer_vpc_id
#   peer_region   = var.vpc_peering_connections[count.index].peer_region
#   vpc_id        = aws_vpc.vpc.id
#   #Accept the peering (both VPCs need to be in the same AWS account).
#   auto_accept = true
#   // accepter {
#   //   allow_remote_vpc_dns_resolution = true
#   // }
#   // requester {
#   //   allow_remote_vpc_dns_resolution = true
#   // }
#   tags = merge(
#     {
#       Name = "${var.env}-central-to-${var.vpc_peering_connections[count.index].account_alias}-pcx"
#     },
#     var.tags
#   )
# }
