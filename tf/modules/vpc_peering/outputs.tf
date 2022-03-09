output "vpc_peering_connectionpeering_peer_ids" {
  value = var.enable_vpc_peering ? aws_vpc_peering_connection.vpc_peering[*].id :  null
}