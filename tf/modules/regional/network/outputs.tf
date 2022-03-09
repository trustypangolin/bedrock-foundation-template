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
