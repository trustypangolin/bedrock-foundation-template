# Allow Grafan Cloud to assume this role to read CLoudWatch metrics
locals {
  grafana_account_id = "008923505280"
}

resource "aws_iam_role" "grafana_labs_cloudwatch_integration" {
  name               = var.grafana_role_name
  description        = "Role used by Grafana CloudWatch Integration."
  assume_role_policy = data.aws_iam_policy_document.trust_grafana.json

  # This policy allows the role to discover metrics via tags and export them.
  inline_policy {
    name = var.grafana_role_name
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "tag:GetResources",
            "cloudwatch:GetMetricData",
            "cloudwatch:GetMetricStatistics",
            "cloudwatch:ListMetrics"
          ]
          Resource = "*"
        }
      ]
    })
  }
}

data "aws_iam_policy_document" "trust_grafana" {
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

output "role_arn" {
  value       = aws_iam_role.grafana_labs_cloudwatch_integration.arn
  description = "The ARN for the role created, copy this into Grafana Cloud installation."
}
