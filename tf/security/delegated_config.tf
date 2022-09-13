resource "aws_organizations_delegated_administrator" "config" {
  provider          = aws.management
  account_id        = data.aws_caller_identity.current.account_id
  service_principal = "config.amazonaws.com"
}

resource "aws_organizations_delegated_administrator" "config-multi" {
  provider          = aws.management
  account_id        = data.aws_caller_identity.current.account_id
  service_principal = "config-multiaccountsetup.amazonaws.com"
}
