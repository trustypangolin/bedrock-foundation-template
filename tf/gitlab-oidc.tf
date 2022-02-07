data "tls_certificate" "gitlab" {
  url = var.gitlab_url
}

resource "aws_iam_openid_connect_provider" "gitlab" {
  url             = var.gitlab_url
  client_id_list  = [var.aud_value]
  thumbprint_list = [data.tls_certificate.gitlab.certificates.0.sha1_fingerprint]
}

data "aws_iam_policy_document" "assume-role-policy-gitlab" {
  statement {
    sid     = "AllowGitLab"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.gitlab.arn]
    }
    condition {
      test     = "StringLike"
      variable = "${aws_iam_openid_connect_provider.gitlab.url}:${var.match_field}"
      values   = var.match_value
    }
  }
}

resource "aws_iam_role" "gitlab_ci" {
  name                 = "GitLab-Bootstrap"
  assume_role_policy   = data.aws_iam_policy_document.assume-role-policy-gitlab.json
  max_session_duration = 3600
}
