
# NAT Gateways
resource "aws_eip" "nat_gw_eips" {
  count = var.number_of_ngws
  vpc   = true
  tags = {
    Name = format("%s-nat-gw", var.env)
  }
}

resource "aws_nat_gateway" "nat_gws" {
  count         = var.number_of_ngws
  allocation_id = aws_eip.nat_gw_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags = {
    Name = format("%s-nat-gw-%s", var.env, data.aws_availability_zone.az[count.index].name_suffix)
  }
}
