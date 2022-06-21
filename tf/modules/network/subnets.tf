data "aws_availability_zone" "az" {
  count = local.number_of_azs
  name  = local.azs[count.index]
}

resource "aws_subnet" "public_subnets" {
  count                   = local.number_of_azs
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]
  tags = {
    Name = format("%s-public-sn-%s", var.env, data.aws_availability_zone.az[count.index].name_suffix)
  }
}



resource "aws_subnet" "private_subnets" {
  count             = local.number_of_azs
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.subnet_cidrs[count.index + 4]
  availability_zone = local.azs[count.index]
  tags = {
    Name = format("%s-private-sn-%s", var.env, data.aws_availability_zone.az[count.index].name_suffix)
  }
}


resource "aws_subnet" "isolated_subnets" {
  count = local.number_of_azs

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.subnet_cidrs[count.index + 8]
  availability_zone = local.azs[count.index]
  tags = {
    Name = format("%s-isolated-sn-%s", var.env, data.aws_availability_zone.az[count.index].name_suffix)
  }
}
