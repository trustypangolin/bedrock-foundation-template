resource "aws_iam_account_alias" "env" {
  account_alias = format("%s-%TEMPLATE%", var.unique_prefix)
}

data "aws_iam_account_alias" "env" {
  depends_on = [
    aws_iam_account_alias.env,
  ]
}
