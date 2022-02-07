data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.github.certificates.2.sha1_fingerprint,
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

data "aws_iam_policy_document" "assume-role-policy-github" {
  statement {
    sid     = "AllowGitHub"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "${aws_iam_openid_connect_provider.github.url}:${var.match_field}"
      values   = var.match_github
    }
  }
}

resource "aws_iam_role" "github_ci" {
  name                 = "Github-Bootstrap"
  assume_role_policy   = data.aws_iam_policy_document.assume-role-policy-github.json
  max_session_duration = 3600
}

