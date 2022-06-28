output "vpc" {
  value = {
    "vpc_id" : aws_vpc.vpc.id,
    "cidr" : aws_vpc.vpc.cidr_block,
    "public" : {
      "subnet_cidrs" : aws_subnet.public_subnets.*.cidr_block,
      "subnet_ids" : aws_subnet.public_subnets.*.id,
      "routetable_ids" : aws_route_table.public_route_tables.*.id
    },
    "private" : {
      "subnet_cidrs" : aws_subnet.private_subnets.*.cidr_block,
      "subnet_ids" : aws_subnet.private_subnets.*.id,
      "routetable_ids" : aws_route_table.private_route_tables.*.id
    },
    "isolated" : {
      "subnet_cidrs" : aws_subnet.isolated_subnets.*.cidr_block,
      "subnet_ids" : aws_subnet.isolated_subnets.*.id,
      "routetable_ids" : aws_route_table.isolated_route_tables.*.id
    },
  }
}

// #TWG
// output "tgw_self_attachment" {
//   value = aws_ec2_transit_gateway_vpc_attachment.attachment_self[*].id
// }

# output "transit_gateway_id" {
#   value = var.create_tgw ? aws_ec2_transit_gateway.transit_gateway[0].id : null
# }

# output "transit_gateway_rt_id" {
#   value = var.create_tgw ? aws_ec2_transit_gateway_route_table.tgw_rt_tbl[0].id : null
# }

# output "transit_gateway_peering_attch_id" {
#   value = var.create_tgw_peering ? aws_ec2_transit_gateway_peering_attachment.tgw_peering_attachment[0].id : null
# }

# output "resource_share_id" {
#   value = var.create_tgw ? aws_ram_resource_share.this[0].id : null
# }

# output "vpc_peering_connectionpeering_peer_ids" {
#   value = var.enable_vpc_peering ? aws_vpc_peering_connection.vpc_peering[*].id :  null
# }
