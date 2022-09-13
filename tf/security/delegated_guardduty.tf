resource "aws_guardduty_detector" "detector" {
  provider = aws.management
  enable   = true
}

resource "aws_guardduty_detector" "security" {
  enable = true
  datasources {
    s3_logs {
      enable = false
    }
  }
}

resource "aws_guardduty_organization_admin_account" "delegate" {
  depends_on       = [aws_guardduty_detector.security]
  provider         = aws.management
  admin_account_id = data.aws_caller_identity.current.id
}

resource "aws_guardduty_organization_configuration" "security" {
  depends_on  = [aws_guardduty_organization_admin_account.delegate]
  auto_enable = true
  detector_id = aws_guardduty_detector.security.id
}
