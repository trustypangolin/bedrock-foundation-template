data "tls_certificate" "gitlab" {
  url = var.gitlab_url
}

resource "aws_iam_openid_connect_provider" "gitlab" {
  count           = var.gitlab == true ? 1 : 0
  url             = var.gitlab_url
  client_id_list  = [var.gitlab_aud]
  thumbprint_list = [data.tls_certificate.gitlab.certificates.0.sha1_fingerprint]
}

data "aws_iam_policy_document" "assume-role-policy-gitlab" {
  count = var.gitlab == true ? 1 : 0
  statement {
    sid     = "AllowGitLab"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.gitlab[0].arn]
    }
    condition {
      test     = "StringLike"
      variable = "${aws_iam_openid_connect_provider.gitlab[0].url}:${var.gitlab_field}"
      values   = var.gitlab_match
    }
  }
}

resource "aws_iam_role" "gitlab_ci" {
  count                = var.gitlab == true ? 1 : 0
  name                 = "GitLab-Bootstrap"
  assume_role_policy   = data.aws_iam_policy_document.assume-role-policy-gitlab[0].json
  max_session_duration = 3600
  inline_policy {
    name   = "GitlabAssume"
    policy = data.aws_iam_policy_document.gitlab_admin.json
  }
}

data "aws_iam_policy_document" "gitlab_admin" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:iam::*:role/bedrock-deploy",
    ]
  }
}
