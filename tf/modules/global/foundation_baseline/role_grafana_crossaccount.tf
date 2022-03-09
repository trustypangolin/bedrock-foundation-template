# Allow Grafan Cloud to assume this role to read CLoudWatch metrics
locals {
  grafana_account_id = "008923505280"
}

resource "aws_iam_role" "grafana_labs_cloudwatch_integration" {
  count              = var.grafana_id == null ? 0 : 1
  name               = var.grafana_role_name
  description        = "Role used by Grafana CloudWatch Integration."
  assume_role_policy = data.aws_iam_policy_document.trust_grafana[0].json

  # This policy allows the role to discover metrics via tags and export them.
  inline_policy {
    name   = var.grafana_role_name
    policy = data.aws_iam_policy_document.grafana[0].json
  }
}


data "aws_iam_policy_document" "trust_grafana" {
  count = var.grafana_id == null ? 0 : 1
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root", local.grafana_account_id)]
    }

    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.grafana_id]
    }
  }
}

data "aws_iam_policy_document" "grafana" {
  count = var.grafana_id == null ? 0 : 1
  statement {
    effect = "Allow"
    actions = [
      "tag:GetResources",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics"
    ]
    resources = ["*"]
  }
}


output "role_arn" {
  value       = length(var.grafana_id) > 0 ? aws_iam_role.grafana_labs_cloudwatch_integration[0].arn : null
  description = "The ARN for the role created, copy this into Grafana Cloud installation."
}
