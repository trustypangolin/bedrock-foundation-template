# Default Variables for all workspaces
locals {
  default = {
    # Remote State Variable Lookups for Default Workspace
    base_region   = data.terraform_remote_state.org.outputs.base_region
    base_role     = data.terraform_remote_state.org.outputs.base_role
    control_tower = data.terraform_remote_state.org.outputs.control_tower
    grafana_id    = data.terraform_remote_state.org.outputs.grafana_id
    notifications = data.terraform_remote_state.org.outputs.notifications
    org_id        = data.terraform_remote_state.org.outputs.org_id
    unique_prefix = data.terraform_remote_state.org.outputs.unique_prefix
    alt_contacts  = data.terraform_remote_state.org.outputs.alt_contacts

    # Account ID Lookups for All accounts - Note, there must be permissions to actually access the role, this isn't given by default
    management = data.terraform_remote_state.org.outputs.acc[data.terraform_remote_state.org.outputs.acc_map["Management"]]
    security   = data.terraform_remote_state.org.outputs.acc[data.terraform_remote_state.org.outputs.acc_map["Security"]]
    production = data.terraform_remote_state.org.outputs.acc[data.terraform_remote_state.org.outputs.acc_map["Production"]]
    central    = data.terraform_remote_state.org.outputs.acc[data.terraform_remote_state.org.outputs.acc_map["Central"]]

    # Local Customisations for this Project
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }

    aws_budgets = 30
    env         = "mgmt"
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
