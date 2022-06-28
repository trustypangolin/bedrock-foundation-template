# GitLab OIDC Connections
data "tls_certificate" "gitlab" {
  url = var.gitlab_url
}

resource "aws_iam_openid_connect_provider" "gitlab" {
  count           = var.gitlab_idp == true ? 1 : 0
  url             = var.gitlab_url
  client_id_list  = [var.gitlab_aud]
  thumbprint_list = [data.tls_certificate.gitlab.certificates.0.sha1_fingerprint]
}

# GitHub OIDC Connections
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  count          = var.github_idp == true ? 1 : 0
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.github.certificates.2.sha1_fingerprint,
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

# Bitbucket OIDC Connections
data "tls_certificate" "bitbucket" {
  url = format("https://api.bitbucket.org/2.0/workspaces/%s/pipelines-config/identity/oidc", var.bitbucket_workspace)
}

resource "aws_iam_openid_connect_provider" "bitbucket" {
  count          = var.bitbucket_idp == true ? 1 : 0
  url            = format("https://api.bitbucket.org/2.0/workspaces/%s/pipelines-config/identity/oidc", var.bitbucket_workspace)
  client_id_list = [format("ari:cloud:bitbucket::workspace/%s", var.bitbucket_workspaceid)]
  thumbprint_list = [
    data.tls_certificate.bitbucket.certificates.0.sha1_fingerprint,
  ]
}

# Roles
resource "aws_iam_role" "bedrock_oidc" {
  name                 = "bedrock-terraform-oidc"
  assume_role_policy   = data.aws_iam_policy_document.trust-oidc.json
  max_session_duration = 3600
  inline_policy {
    name   = "allowassume"
    policy = data.aws_iam_policy_document.allow_assume.json
  }
  inline_policy {
    name   = "TerraformState"
    policy = data.aws_iam_policy_document.tf_state.json
  }
}

data "aws_iam_policy_document" "trust-oidc" {
  dynamic "statement" {
    for_each = var.github_role ? [1] : []
    content {
      sid     = "AllowGitHub"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type        = "Federated"
        identifiers = var.github_idp ? [aws_iam_openid_connect_provider.github[0].arn] : [format("arn:aws:iam::%s:oidc-provider/token.actions.githubusercontent.com", data.aws_caller_identity.current.account_id)]
      }
      condition {
        test     = "StringLike"
        variable = var.github_idp ? format("%s:%s", aws_iam_openid_connect_provider.github[0].url, var.github_field) : "token.actions.GitHubusercontent.com:sub"
        values   = [var.github_match]
      }
    }
  }


  dynamic "statement" {
    for_each = var.gitlab_role ? [1] : []
    content {
      sid     = "AllowGitLab"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type        = "Federated"
        identifiers = var.gitlab_idp ? [aws_iam_openid_connect_provider.gitlab[0].arn] : [format("arn:aws:iam::%s:oidc-provider/gitlab.com", data.aws_caller_identity.current.account_id)]
      }
      condition {
        test     = "StringLike"
        variable = var.gitlab_idp ? format("%s:%s", aws_iam_openid_connect_provider.gitlab[0].url, var.gitlab_field) : "gitlab.com:sub"
        values   = [var.gitlab_match]
      }
    }
  }


  dynamic "statement" {
    for_each = var.bitbucket_role ? [1] : []
    content {
      sid     = "AllowBitbucket"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals {
        type        = "Federated"
        identifiers = var.bitbucket_idp ? [aws_iam_openid_connect_provider.bitbucket[0].arn] : [format("arn:aws:iam::%s:oidc-provider/api.Bitbucket.org/2.0/workspaces/%s/pipelines-config/identity/oidc", data.aws_caller_identity.current.account_id, var.bitbucket_workspaceid)]
      }
      condition {
        test     = "StringLike"
        variable = format("%s:aud", "arn:aws:iam::152848913167:oidc-provider/api.Bitbucket.org/2.0/workspaces/yourworkspaceid/pipelines-config/identity/oidc")
        values   = [format("ari:cloud:bitbucket::workspace/%s", var.bitbucket_workspaceid)]
      }
    }
  }

  # Allow BedrockAdmin to Assume this role STS
  dynamic "statement" {
    for_each = var.source_account != null ? [1] : []
    content {
      sid = "AllowBedrockAdmin"
      actions = [
        "sts:AssumeRole"
      ]
      principals {
        type        = "AWS"
        identifiers = [format("arn:aws:iam::%s:role/BedrockAdmin", var.source_account)]
      }
    }
  }
}

data "aws_iam_policy_document" "allow_assume" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:iam::*:role/bedrock-deploy",
    ]
  }
}

resource "aws_iam_role" "bedrock_deploy" {
  name                 = "bedrock-deploy"
  assume_role_policy   = data.aws_iam_policy_document.role_trust.json
  max_session_duration = 43200
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

data "aws_iam_policy_document" "role_trust" {
  statement {
    sid = "AllowDeploymentAdmin"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.bedrock_oidc.arn]
    }
  }
}

# OIDC entry Role requires access to TF State for basic functionality in addition to the ability to assume the deployment roles
# This ensures that if the aws provider isnt configured for roles correctly, that no resources can be created in the wrong account
# Additional Policy Documents and Roles can be created for restricted access to developers, this is generally done via SSO Permission Sets
data "aws_iam_policy_document" "tf_state" {
  statement {
    sid       = "AccessListS3"
    effect    = "Allow"
    resources = [aws_s3_bucket.tfstate.arn]
    actions   = ["s3:ListBucket"]
  }

  statement {
    sid       = "AccessS3All"
    effect    = "Allow"
    resources = ["arn:aws:s3:::*"]

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]
  }

  statement {
    sid    = "AccessS3"
    effect = "Allow"

    resources = [
      format("%s/bedrock/*", aws_s3_bucket.tfstate.arn),     # Allow access to bedrock state objects
      format("%s/application/*", aws_s3_bucket.tfstate.arn), # For an application stack using workspaces
      format("%s/fullstack", aws_s3_bucket.tfstate.arn),     # for an application default workspace
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetEncryptionConfiguration",
      "s3:DeleteObject",
    ]
  }

  statement {
    sid       = "AccessDynamoDB"
    effect    = "Allow"
    resources = [aws_dynamodb_table.terraform.arn]

    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
    ]
  }

  statement {
    sid       = "AssumeAll"
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/bedrock-deploy"]
    actions   = ["sts:AssumeRole"]
  }
}
