resource "aws_budgets_budget" "all_accounts_budget" {
  count             = var.enable_budgets ? 1 : 0
  name              = "AWS Budget"
  limit_amount      = var.aws_budgets
  budget_type       = "COST"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2022-07-01_00:00"
  cost_types {
    include_credit             = false
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = false
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notifications.billing]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.notifications.billing]
  }
}
