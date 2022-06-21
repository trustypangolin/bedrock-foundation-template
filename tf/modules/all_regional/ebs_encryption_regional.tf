resource "aws_ebs_encryption_by_default" "eu-north-1" {
  provider      = aws.eu-north-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "ap-south-1" {
  provider      = aws.ap-south-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "eu-west-3" {
  provider      = aws.eu-west-3
  enabled = true
}

resource "aws_ebs_encryption_by_default" "eu-west-2" {
  provider      = aws.eu-west-2
  enabled = true
}

resource "aws_ebs_encryption_by_default" "eu-west-1" {
  provider      = aws.eu-west-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "ap-northeast-2" {
  provider      = aws.ap-northeast-2
  enabled = true
}

resource "aws_ebs_encryption_by_default" "ap-northeast-1" {
  provider      = aws.ap-northeast-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "sa-east-1" {
  provider      = aws.sa-east-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "ca-central-1" {
  provider      = aws.ca-central-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "ap-southeast-1" {
  provider      = aws.ap-southeast-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "eu-central-1" {
  provider      = aws.eu-central-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "us-east-1" {
  provider      = aws.us-east-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "us-east-2" {
  provider      = aws.us-east-2
  enabled = true
}

resource "aws_ebs_encryption_by_default" "us-west-1" {
  provider      = aws.us-west-1
  enabled = true
}

resource "aws_ebs_encryption_by_default" "us-west-2" {
  provider      = aws.us-west-2
  enabled = true
}

