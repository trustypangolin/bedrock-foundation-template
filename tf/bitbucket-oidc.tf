variable "bitbucket_workspace" {
  type = string
}

variable "bitbucket_workspaceid" {
  type = string
}


data "tls_certificate" "bitbucket" {
  url = format("https://api.bitbucket.org/2.0/workspaces/%s/pipelines-config/identity/oidc", var.bitbucket_workspace)
}

resource "aws_iam_openid_connect_provider" "bitbucket" {
  url            = format("https://api.bitbucket.org/2.0/workspaces/%s/pipelines-config/identity/oidc", var.bitbucket_workspace)
  client_id_list = [format("ari:cloud:bitbucket::workspace/%s", var.bitbucket_workspaceid)]
  thumbprint_list = [
    data.tls_certificate.bitbucket.certificates.0.sha1_fingerprint,
  ]
}

data "aws_iam_policy_document" "assume-role-policy-bitbucket" {
  statement {
    sid     = "AllowBitbucket"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.bitbucket.arn]
    }
    condition {
      test     = "StringLike"
      variable = format("%s:aud", aws_iam_openid_connect_provider.bitbucket.url)
      values   = [format("ari:cloud:bitbucket::workspace/%s", var.bitbucket_workspaceid)]
    }
  }
}

resource "aws_iam_role" "bitbucket_ci" {
  name                 = "Bitbucket-Bootstrap"
  assume_role_policy   = data.aws_iam_policy_document.assume-role-policy-bitbucket.json
  max_session_duration = 3600
  inline_policy {
    name   = "BitbucketAssume"
    policy = data.aws_iam_policy_document.bitbucket_admin.json
  }
}

data "aws_iam_policy_document" "bitbucket_admin" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:iam::*:role/Bitbucket-*",
    ]
  }
}

resource "aws_iam_role" "bitbucket_admin" {
  name                 = "Bitbucket-Admin"
  assume_role_policy   = data.aws_iam_policy_document.bitbucket_entry.json
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  max_session_duration = 43200

}

data "aws_iam_policy_document" "bitbucket_entry" {
  statement {
    sid     = "AllowBitbucket"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.bitbucket_ci.arn]
    }
  }
}
