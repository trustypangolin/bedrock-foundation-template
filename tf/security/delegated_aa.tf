resource "aws_organizations_delegated_administrator" "aa" {
  provider          = aws.management
  account_id        = data.aws_caller_identity.current.account_id
  service_principal = "access-analyzer.amazonaws.com"
}

resource "aws_iam_service_linked_role" "aa" {
  provider         = aws.management
  aws_service_name = "access-analyzer.amazonaws.com"
}

resource "aws_accessanalyzer_analyzer" "org" {
  depends_on = [
    aws_organizations_delegated_administrator.aa,
    aws_iam_service_linked_role.aa
  ]
  analyzer_name = format("%s-org", local.workspace["unique_prefix"])
  type          = "ORGANIZATION"
}

resource "aws_accessanalyzer_analyzer" "s3" {
  depends_on = [
    aws_organizations_delegated_administrator.aa,
    aws_iam_service_linked_role.aa
  ]
  analyzer_name = format("%s-account", local.workspace["unique_prefix"])
  type          = "ACCOUNT"
}
