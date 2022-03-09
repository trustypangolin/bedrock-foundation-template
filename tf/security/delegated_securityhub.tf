resource "aws_securityhub_account" "hub" {
  provider = aws.management
}

resource "aws_securityhub_organization_admin_account" "hub" {
  depends_on       = [aws_securityhub_account.hub]
  provider         = aws.management
  admin_account_id = data.aws_caller_identity.current.id
}

resource "aws_securityhub_organization_configuration" "hub" {
  depends_on  = [aws_securityhub_organization_admin_account.hub]
  auto_enable = true
}

resource "aws_securityhub_finding_aggregator" "hub" {
  linking_mode = "ALL_REGIONS"
  depends_on   = [aws_securityhub_organization_configuration.hub]
}
