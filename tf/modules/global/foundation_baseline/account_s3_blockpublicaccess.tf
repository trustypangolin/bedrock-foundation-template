resource "aws_s3_account_public_access_block" "block_all" {
  count                   = var.public_s3_block == true ? 1 : 0
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
