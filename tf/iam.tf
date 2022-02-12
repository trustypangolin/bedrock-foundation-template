resource "aws_iam_role" "bedrock" {
  name                 = "bedrock-deploy"
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
      type = "AWS"
      identifiers = [
        # Modify these, and remove the Git OIDC you do not require
        aws_iam_role.gitlab_ci.arn,
        aws_iam_role.github_ci.arn,
        aws_iam_role.bitbucket_ci.arn
      ]
    }
  }
}
