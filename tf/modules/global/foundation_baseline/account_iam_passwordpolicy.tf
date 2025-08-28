resource "aws_iam_account_password_policy" "strict" {
  count                          = var.password_policy == true ? 1 : 0
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90 # Number of days
}
