# Default Variables for all workspaces
locals {
  default = {
    acc_map       = var.acc_map       # Lookup Map for {Account Names => IDs}. We don't specify Account IDs in code ever, we do a lookup from the Org, and match a friendly name
    alt_contacts  = var.alt_contacts  # Alernate Contact List
    base_region   = var.base_region   # Base Region for providers and resources 
    base_role     = var.base_role     # Base Role for providers
    control_tower = var.control_tower # Control Tower Status, Some resources are managed by Control Tower separately
    grafana_id    = var.grafana_id    # If Grafana Cloud is being utilised for CloudWatch Metrics, set it here, this could be replaced with anything global, eg DataDog
    notifications = var.notifications # Notification Email addresses
    root_emails   = var.root_emails   # Only used in Non-Control Tower Installs, these would be the Account Factory values
    unique_prefix = var.unique_prefix # Unique prefix for resources like S3 Buckets and Global Unique Resources, eg AWS IAM Account Aliases
  }
}

locals {
  # A workaround based on https://github.com/hashicorp/terraform/issues/15966
  workspaces = merge(
    local.default,
    local.bedrock_demo, # Bedrock Demo env file
  )

  workspace = terraform.workspace == "default" ? local.default : merge(local.default, local.workspaces[terraform.workspace])
}
