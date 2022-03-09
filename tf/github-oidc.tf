data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  count           = var.github == true ? 1 : 0
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
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
      identifiers = [aws_iam_openid_connect_provider.github[0].arn]
    }
    condition {
      test     = "StringLike"
      variable = "${aws_iam_openid_connect_provider.github[0].url}:${var.github_field}"
      values   = var.github_match
    }
  }
}

resource "aws_iam_role" "github_ci" {
  count                = var.github == true ? 1 : 0
  name                 = "Github-Bootstrap"
  assume_role_policy   = data.aws_iam_policy_document.assume-role-policy-github.json
  max_session_duration = 3600
  inline_policy {
    name   = "GithubAssume"
    policy = data.aws_iam_policy_document.github_admin.json
  }
}

data "aws_iam_policy_document" "github_admin" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:iam::*:role/bedrock-deploy",
    ]
  }
}
