## VPC Outputs
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

## Subnet Outputs
output "subnet_ids" {
  value = concat(
    aws_subnet.public_subnets.*.id,
    aws_subnet.private_subnets.*.id,
    aws_subnet.isolated_subnets.*.id
  )
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "private_subnet_cidrs" {
  value = aws_subnet.private_subnets.*.cidr_block
}

output "isolated_subnet_ids" {
  value = aws_subnet.isolated_subnets.*.id
}

output "isolated_subnet_cidrs" {
  value = aws_subnet.isolated_subnets.*.cidr_block
}

## Route Table outputs
output "public_rt_ids" {
  value = aws_route_table.public_route_tables.*.id
}

output "private_rt_ids" {
  value = aws_route_table.private_route_tables.*.id
}

output "isolated_rt_ids" {
  value = aws_route_table.isolated_route_tables.*.id
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
