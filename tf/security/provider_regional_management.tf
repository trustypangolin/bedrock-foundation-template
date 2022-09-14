provider "aws" {
  region = "eu-north-1"
  alias  = "management-eu-north-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-ap-south-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-eu-west-3"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-eu-west-2"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-eu-west-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-ap-northeast-2"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-ap-northeast-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-sa-east-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-ca-central-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-ap-southeast-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  region = "ap-southeast-2"
  alias  = "management-ap-southeast-2"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-eu-central-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-us-east-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-us-east-2"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-us-west-1"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
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
  alias  = "management-us-west-2"
  assume_role {
    role_arn     = format("arn:aws:iam::%s:role/%s", local.workspace["management"], local.workspace["base_role"])
    session_name = "terraform"
  }
  default_tags {
    tags = {
      Service = "Bedrock",
      Version = "3.0.0"
    }
  }
}
