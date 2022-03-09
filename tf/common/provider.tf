terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

data "aws_regions" "current" {}
data "aws_caller_identity" "current" {}

# Pick your default provider for the folder and delete the rest, or add aliases for mutliple account access

provider "aws" {
  region              = var.base_region
  allowed_account_ids = [lookup(data.terraform_remote_state.org.outputs.acc, "Management")]
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "Management"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "Security"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "Log Archive"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "Shared"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "Production"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "Staging"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "Testing"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "Development"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "UAT"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}

provider "aws" {
  region = var.base_region
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", lookup(data.terraform_remote_state.org.outputs.acc, "NonProd"))
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock"
      Version = "3.0.0"
    }
  }
}
