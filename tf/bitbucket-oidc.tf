data "tls_certificate" "bitbucket" {
  url = format("https://api.bitbucket.org/2.0/workspaces/%s/pipelines-config/identity/oidc", var.bitbucket_workspace)
}

resource "aws_iam_openid_connect_provider" "bitbucket" {
  count           = var.bitbucket == true ? 1 : 0
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
      identifiers = [aws_iam_openid_connect_provider.bitbucket[0].arn]
    }
    condition {
      test     = "StringLike"
      variable = format("%s:aud", aws_iam_openid_connect_provider.bitbucket[0].url)
      values   = [format("ari:cloud:bitbucket::workspace/%s", var.bitbucket_workspaceid)]
    }
  }
}

resource "aws_iam_role" "bitbucket_ci" {
  count                = var.bitbucket == true ? 1 : 0
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
      "arn:aws:iam::*:role/bedrock-deploy",
    ]
  }
}
