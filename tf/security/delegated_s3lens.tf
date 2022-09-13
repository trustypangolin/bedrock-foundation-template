resource "aws_organizations_delegated_administrator" "s3lens" {
  provider          = aws.management
  account_id        = data.aws_caller_identity.current.account_id
  service_principal = "storage-lens.s3.amazonaws.com"
}
