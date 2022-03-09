resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "DO NOT USE, DO NOT ADD RULES"
  }
}
resource "aws_security_group" "linux-mgmt-sg" {
  name        = "Linux Management Group"
  description = "Allow SSH connection to Instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH Connection to Instances"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Allows egress to all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-linux-mgmt-sg"
  }
}


resource "aws_security_group" "windows-mgmt-sg" {
  name        = "Windows Management Group"
  description = "Allow connection to Windows Instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "RDP Connection to Instances"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Allows egress to all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-windows-mgmt-sg"
  }
}
