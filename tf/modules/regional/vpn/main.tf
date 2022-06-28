locals {
  standard_tags = [
    {
      active = true
      name   = "Name"
      value  = format("%s-pritunl", var.env)
    },
    {
      active = var.backup
      name   = "backup"
      value  = "true"
    },
    {
      active = var.autossmpatchprod
      name   = "bedrock-prod-patching"
      value  = "true"
    },
    {
      active = var.autossmpatchnonprod
      name   = "bedrock-nonprod-patching"
      value  = "true"
    },
  ]
}

data "aws_ami" "amazonlinux2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_security_group" "pritunl-mgmt-sg" {
  name        = "Pritunl Management Group"
  description = "Allow Pritunl connection to Instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP Connection to Instances for Cert"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Connection to Instances"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "VPN Connection to Instances"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Wireguard Connection to Instances"
    from_port   = 1195
    to_port     = 1195
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allows egress to all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = format("%s-pritunl-mgmt-sg", var.env)
  }
}

resource "aws_eip" "awsip" {
  vpc              = true
  public_ipv4_pool = "amazon"
  instance         = aws_instance.vpn.id
  tags = {
    Name = format("%s-pritunl", var.env)
  }
}

resource "aws_network_interface" "vpn" {
  description     = "Pritunl Public IP"
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.pritunl-mgmt-sg.id]
  tags = {
    Name = format("%s-pritunl", var.env)
  }
}

data "aws_iam_policy_document" "instanceassumepolicy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ssm.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDocument",
      "ssm:ListAssociations",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceInformation"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }

  statement {
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListObjects"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "role" {
  name = format("bedrock-VPN-Role-%s", data.aws_region.current.name)
  path = "/"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  assume_role_policy = data.aws_iam_policy_document.instanceassumepolicy.json
  inline_policy {
    name   = "policy-vpn"
    policy = data.aws_iam_policy_document.inline_policy.json
  }
}

resource "aws_iam_instance_profile" "vpn_profile" {
  name = format("bedrock-VPN-Profile-%s", data.aws_region.current.name)
  role = aws_iam_role.role.name
}

resource "aws_instance" "vpn" {
  ami           = data.aws_ami.amazonlinux2.id
  instance_type = var.instance_type
  key_name      = "bedrock-central"
  user_data     = templatefile("${path.module}/userdata/userdata.sh", { unique_prefix = var.unique_prefix })
  network_interface {
    network_interface_id = aws_network_interface.vpn.id
    device_index         = 0
  }
  iam_instance_profile = aws_iam_instance_profile.vpn_profile.id

  tags = {
    # Name = format("%s-pritunl", var.env)
    for tag in local.standard_tags :
    tag.name => tag.value
    if tag.active
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [ami]
  }
}

resource "aws_s3_bucket" "pritunl" {
  bucket = format("%s-pritunl-backups", var.unique_prefix)
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config_delivery" {
  bucket = aws_s3_bucket.pritunl.bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "pritunl" {
  bucket = aws_s3_bucket.pritunl.id
  policy = data.aws_iam_policy_document.pritunl.json
}

data "aws_iam_policy_document" "pritunl" {
  statement {
    sid       = "ForceSSLOnlyAccess"
    effect    = "Deny"
    resources = [format("arn:aws:s3:::%s-pritunl-backups/*", var.unique_prefix)]
    actions   = ["s3:*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

# Block public access
#--------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "pritunl" {
  bucket                  = aws_s3_bucket.pritunl.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket_policy.pritunl
  ]
}
