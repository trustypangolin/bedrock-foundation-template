terraform {
  required_version = "~> 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# The Org project does not assume a role within the provider block, so for this project to work either:
# (a). GitHub Actions has assumed the foundation-tf-state or equivalent permission limited role 
# OR
# (b). Terraform is running from CLI, or another process with the enough permissions to read/write state and
#      create any resources needed within this folder.

# The Org Project is designed to export Account Names, Numbers, global params as Output Mappings, and 
# some basic Organization tasks that are not covered with Control Tower when that is active

# The org state object must be locked down to read-only for most users/roles outside this project, and
# it is referenced as a remote state in all projects to maintain code 'dryness' as much as possible

# Terraform Workspaces is configured to allow for multi-org setup (workspaces.tf), where a non-prod AWS Organization is required

provider "aws" {
  region = local.workspace["base_region"]
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
