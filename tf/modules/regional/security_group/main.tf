resource "aws_security_group" "instance" {
  name        = var.name
  description = format("Used in %s", var.env)
  vpc_id      = var.vpc_id
  tags = {
    Name = format("%s", var.name)
  }
}

# We separate the rules from the aws_security_group because then we can manipulate the 
# aws_security_group outside of this module
resource "aws_security_group_rule" "outbound_internet_access" {
  count             = var.include_outbound == true ? 1 : 0
  description       = "Default Outbound All Rule"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance.id
}
