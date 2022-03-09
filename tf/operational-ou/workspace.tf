# Default Variables for all workspaces
locals {
  default = {
    default = {
      base_region = "ap-southeast-2"
      acc_map = {
        Management  = "Management"
        Security    = "Security"
        Central     = "Central"
        Production  = "Production"
        Development = "Development"
      }
    }
  }
}

locals {
  # A workaround based on https://github.com/hashicorp/terraform/issues/15966
  workspaces = merge(
    local.default,
    local.bedrock_demo, # Bedrock Demo env file
  )
  workspace = merge(local.default, local.workspaces[terraform.workspace])
}
