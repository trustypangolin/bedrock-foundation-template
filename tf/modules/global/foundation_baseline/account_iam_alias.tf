resource "aws_iam_account_alias" "env" {
  count         = var.iam_account_name == true ? 1 : 0
  account_alias = format("%s-%s", var.unique_prefix, var.alias_name)
}

data "aws_iam_account_alias" "env" {
  count = var.iam_account_name == true ? 1 : 0
  depends_on = [
    aws_iam_account_alias.env[0],
  ]
}
