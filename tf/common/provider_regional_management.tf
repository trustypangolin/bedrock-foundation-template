provider "aws" {
  region = "eu-north-1"
  alias  = "eu-north-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
  alias  = "ap-south-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "eu-west-3"
  alias  = "eu-west-3"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "eu-west-2"
  alias  = "eu-west-2"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "eu-west-1"
  alias  = "eu-west-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "ap-northeast-2"
  alias  = "ap-northeast-2"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "ap-northeast-1"
  alias  = "ap-northeast-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "sa-east-1"
  alias  = "sa-east-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "ca-central-1"
  alias  = "ca-central-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "ap-southeast-1"
  alias  = "ap-southeast-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "eu-central-1"
  alias  = "eu-central-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "us-east-2"
  alias  = "us-east-2"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "us-west-1"
  alias  = "us-west-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/bedrock-terraform", data.terraform_remote_state.org.outputs.acc[lookup(var.acc_map, "Management")])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
