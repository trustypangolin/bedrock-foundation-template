# Workspace specific variables
locals {
  bedrock_demo = {
    bedrock_demo = {
      unique_prefix = "indigocapybara"
      acc_map = {
        Management  = "Management"
        Security    = "Security"
        Central     = "Shared"
        Production  = "Production"
        Development = "Development"
      }
    }
  }
}
