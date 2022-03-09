# Workspace specific variables
locals {
  bedrock_demo = {
    bedrock_demo = {
      # This a place holder for default overrides for a workspace called bedrock_demo. 
      # base_region   = data.terraform_remote_state.org_diff.outputs.base_region
      # base_role     = data.terraform_remote_state.org_diff.outputs.base_role
      # control_tower = data.terraform_remote_state.org_diff.outputs.control_tower
      # grafana_id    = data.terraform_remote_state.org_diff.outputs.grafana_id
      # notifications = data.terraform_remote_state.org_diff.outputs.notifications
      # org_id        = data.terraform_remote_state.org_diff.outputs.org_id
      # unique_prefix = data.terraform_remote_state.org_diff.outputs.unique_prefix
      # alt_contacts  = data.terraform_remote_state.org_diff.outputs.alt_contacts

      # Account ID Lookups for All accounts - Note, there must be permissions to actually access the role, this isn't given by default
      # management = data.terraform_remote_state.org_diff.outputs.acc[data.terraform_remote_state.org.outputs.acc_map["Management"]]
      # security   = data.terraform_remote_state.org_diff.outputs.acc[data.terraform_remote_state.org.outputs.acc_map["Security"]]
      # logarchive = data.terraform_remote_state.org_diff.outputs.acc[data.terraform_remote_state.org.outputs.acc_map["LogArchive"]]
      # central    = data.terraform_remote_state.org_diff.outputs.acc[data.terraform_remote_state.org.outputs.acc_map["Central"]]

      # Overrides Local Customisations for this Project
      # tags = {
      #   Service = "Bedrock",
      #   Version = "3.0.0"
      # }
    }
  }
}
