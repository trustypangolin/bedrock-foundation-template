variable "gitlab_url" {
  type    = string
  default = "https://gitlab.com"
}

variable "aud_value" {
  type    = string
  default = "https://gitlab.com"
}
variable "gitlab_field" {
  type    = string
  default = "sub"
}

variable "gitlab_match" {
  type = list(any)
}

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
      variable = "${aws_iam_openid_connect_provider.gitlab.url}:${var.gitlab_field}"
      values   = var.gitlab_match
    }
  }
}

resource "aws_iam_role" "gitlab_ci" {
  name                 = "GitLab-Bootstrap"
  assume_role_policy   = data.aws_iam_policy_document.assume-role-policy-gitlab.json
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
      "arn:aws:iam::*:role/Gitlab-*",
    ]
  }
}

resource "aws_iam_role" "gitlab_admin" {
  name                 = "GitLab-Admin"
  assume_role_policy   = data.aws_iam_policy_document.gitlab_entry.json
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  max_session_duration = 43200

}

data "aws_iam_policy_document" "gitlab_entry" {
  statement {
    sid     = "AllowGitLab"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.gitlab_ci.arn]
    }
  }
}
