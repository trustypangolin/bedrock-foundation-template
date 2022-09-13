resource "aws_iam_role" "bedrock" {
  name                 = var.base_role
  description          = "Terraform will specifiy this role in provider.tf to deploy resources"
  assume_role_policy   = data.aws_iam_policy_document.bedrock_trust.json
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  max_session_duration = 43200
}

data "aws_iam_policy_document" "bedrock_trust" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}
