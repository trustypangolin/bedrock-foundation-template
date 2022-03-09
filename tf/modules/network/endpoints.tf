###### S3 Gateway 
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = concat(
    aws_route_table.public_route_tables.*.id,
    aws_route_table.private_route_tables.*.id,
    aws_route_table.isolated_route_tables.*.id
  )
  tags = {
    Name = "${var.env}-s3-vpce"
  }
}

###### DynamoDB Gateway 
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  route_table_ids = concat(
    aws_route_table.public_route_tables.*.id,
    aws_route_table.private_route_tables.*.id,
    aws_route_table.isolated_route_tables.*.id
  )
  tags = {
    Name = "${var.env}-dynamodb-vpce"
  }
}

#VPC Endpoint SG
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "VPC Endpoint Group"
  vpc_id      = aws_vpc.vpc.id
  description = "Allow traffic through VPC Endpoint"
  tags = {
    Name = "${var.env}-vpc-endpoint-sg"
  }
}

resource "aws_security_group_rule" "vpc_endpoint_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "Allow Access to Local VPC"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.vpc_endpoint_sg.id
}


#######################
# VPC Endpoint for SSM
#######################
resource "aws_vpc_endpoint" "ssm" {
  count = var.enable_ssm_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = aws_subnet.private_subnets.*.id
  private_dns_enabled = true
  tags = {
    Name = "${var.env}-ssm-vpce"
  }
}

###############################
# VPC Endpoint for SSMMESSAGES
###############################
resource "aws_vpc_endpoint" "ssmmessages" {
  count = var.enable_ssm_endpoint ? 1 : 0

  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = aws_subnet.private_subnets.*.id
  private_dns_enabled = true
  tags = {
    Name = "${var.env}-ssm-messages-vpce"
  }
}

###############################
# VPC Endpoint for EC2MESSAGES
###############################
resource "aws_vpc_endpoint" "ec2messages" {
  count = var.enable_ec2messages_endpoint || var.enable_ssm_endpoint ? 1 : 0

  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = aws_subnet.private_subnets.*.id
  private_dns_enabled = true
  tags = {
    Name = "${var.env}-ec2-messages-vpce"
  }
}

#######################
# VPC Endpoint for EC2
#######################
resource "aws_vpc_endpoint" "ec2" {
  count = var.enable_ec2_endpoint ? 1 : 0

  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ec2"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = aws_subnet.private_subnets.*.id
  private_dns_enabled = true
  tags = {
    Name = "${var.env}-ec2-vpce"
  }
}

#######################
# VPC Endpoint for API Gateway
#######################
data "aws_vpc_endpoint_service" "apigw" {
  count   = var.enable_apigw_endpoint ? 1 : 0
  service = "execute-api"
}

resource "aws_vpc_endpoint" "apigw" {
  count               = var.enable_apigw_endpoint ? 1 : 0
  vpc_id              = aws_vpc.vpc.id
  service_name        = data.aws_vpc_endpoint_service.apigw[0].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = aws_subnet.private_subnets.*.id
  private_dns_enabled = true
  tags = {
    Name = "${var.env}-api-gateway-vpce"
  }
}

##################################
# VPC Endpoint for CloudWatch Logs
##################################
resource "aws_vpc_endpoint" "logs" {
  count               = var.enable_logs_endpoint ? 1 : 0
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = aws_subnet.private_subnets.*.id
  private_dns_enabled = true
  tags = {
    Name = "${var.env}-cloudwatch-log-vpce"
  }
}

########################################
# VPC Endpoint for CloudWatch Monitoring
########################################
resource "aws_vpc_endpoint" "monitoring" {
  count = var.enable_monitoring_endpoint ? 1 : 0

  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.monitoring"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = aws_subnet.private_subnets.*.id
  private_dns_enabled = true
  tags = {
    Name = "${var.env}-Cloudwatch-monitoring-vpce"
  }
}
