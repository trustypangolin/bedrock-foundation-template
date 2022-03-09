resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = {
    Name = "DO NOT USE, DO NOT ADD ROUTES"
  }
}


######## Public Routing
resource "aws_route_table" "public_route_tables" {
  count  = local.number_of_azs
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-public-rt-${data.aws_availability_zone.az[count.index].name_suffix}"
    #Name  = "${var.unique_prefix}-${var.workload_environment}-public-rt-${trimprefix(local.azs[count.index], data.aws_region.current.name)}"
  }
}

resource "aws_route_table_association" "rt_assocations_public" {
  count          = local.number_of_pub_subnets
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_tables[count.index].id
}

resource "aws_route" "public_to_igw" {
  count                  = local.number_of_pub_subnets
  route_table_id         = aws_route_table.public_route_tables[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


######## Private Routing
resource "aws_route_table" "private_route_tables" {
  count  = local.number_of_priv_subnets
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-private-rt-${data.aws_availability_zone.az[count.index].name_suffix}"
    #Name  = "${var.unique_prefix}-${var.workload_environment}-private-rt-${trimprefix(local.azs[count.index], data.aws_region.current.name)}"
  }
}

resource "aws_route_table_association" "rt_assocations_private" {
  count          = local.number_of_priv_subnets
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}

#Routes

resource "aws_route" "private_singleaz_nat_gtw_routes" {
  count                  = var.number_of_ngws == 1 ? 3 : 0
  route_table_id         = aws_route_table.private_route_tables[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gws[0].id
}

resource "aws_route" "private_multiaz_2nat_gtw_routes" {
  count                  = var.number_of_ngws == 2 ? 2 : 0
  route_table_id         = aws_route_table.private_route_tables[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gws[count.index].id
}

resource "aws_route" "private_multiaz_3nat_gtw_routes" {
  count                  = var.number_of_ngws == 3 ? var.number_of_ngws : 0
  route_table_id         = aws_route_table.private_route_tables[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gws[count.index].id
}


######### isolated Routing
resource "aws_route_table" "isolated_route_tables" {
  count  = local.number_of_sec_subnets
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-isolated-rt-${data.aws_availability_zone.az[count.index].name_suffix}"
    #Name  = "${var.unique_prefix}-${var.workload_environment}-isolated-rt-${trimprefix(local.azs[count.index], data.aws_region.current.name)}"
  }
}

resource "aws_route_table_association" "rt_assocations_isolated" {
  count          = local.number_of_sec_subnets
  subnet_id      = aws_subnet.isolated_subnets[count.index].id
  route_table_id = aws_route_table.isolated_route_tables[count.index].id
}

