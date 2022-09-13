# Default Variables for all workspaces
locals {
  default = {
    default = {
      base_region            = local.base_region
      vpccidr                = "10.0"
      number_of_ngws         = 0
      solution_cloudfront_s3 = true
      solution_ec2_vpc       = false
    }
  }
}

locals {
  central_ap-southeast-1 = {
    central_ap-southeast-1 = {
      base_region            = "ap-southeast-1"
      vpccidr                = "10.10"
      number_of_ngws         = 0
      solution_cloudfront_s3 = false
      solution_ec2_vpc       = false
    }
  }
}

locals {
  # A workaround based on https://github.com/hashicorp/terraform/issues/15966
  workspaces = merge(
    local.default,
    local.central_ap-southeast-1, # Central Singapore
  )
  workspace = merge(local.default, local.workspaces[terraform.workspace])
  region    = local.workspace.base_region
}
