locals {
  RegionMap = {
    # US Regions
    "us-east-1" = "America/New_York"
    "us-east-2" = "America/Los_Angeles"
    "us-west-1" = "America/New_York"
    "us-west-2" = "America/Boise"

    # Asia Pacific Regions
    "ap-south-1"     = "Asia/Kolkata"
    "ap-northeast-2" = "Asia/Seoul"
    "ap-southeast-1" = "Asia/Singapore"
    "ap-southeast-2" = "Australia/Sydney"
    "ap-northeast-1" = "Asia/Tokyo"

    # Canada Regions
    "ca-central-1" = "America/Toronto"

    # Europe Region
    "eu-central-1" = "CET"
    "eu-west-1"    = "Europe/London"
    "eu-west-2"    = "Europe/London"
    "eu-west-3"    = "CET"

    # South America Regions
    "sa-east-1" = "America/Sao_Paulo"
  }
}

resource "aws_ssm_maintenance_window" "production" {
  name              = "bedrock-AutomatedPatching-Prod"
  schedule          = var.scheduleprod
  schedule_timezone = local.RegionMap[data.aws_region.current.name]
  duration          = 3
  cutoff            = 1
}

resource "aws_ssm_maintenance_window" "nonproduction" {
  name              = "bedrock-AutomatedPatching-NonProd"
  schedule          = var.schedulenonprod
  schedule_timezone = local.RegionMap[data.aws_region.current.name]
  duration          = 3
  cutoff            = 1
}

resource "aws_ssm_maintenance_window_target" "prod" {
  window_id     = aws_ssm_maintenance_window.production.id
  name          = "PatchingEC2Instances"
  description   = "Instances to patch with the following tags of: bedrock-prod-patching"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:bedrock-prod-patching"
    values = ["true"]
  }
}

resource "aws_ssm_maintenance_window_target" "nonprod" {
  window_id     = aws_ssm_maintenance_window.nonproduction.id
  name          = "PatchingEC2Instances"
  description   = "Instances to patch with the following tags of: bedrock-nonprod-patching"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:bedrock-nonprod-patching"
    values = ["true"]
  }
}

resource "aws_ssm_maintenance_window_task" "prodssmagentupdate" {
  name            = "bedrock-Update-SSMAgent-Prod"
  max_concurrency = 7
  max_errors      = 1
  priority        = 2
  task_arn        = "AWS-UpdateSSMAgent"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.production.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.prod.id]
  }
}

resource "aws_ssm_maintenance_window_task" "nonprodssmagentupdate" {
  name            = "bedrock-Update-SSMAgent-NonProd"
  max_concurrency = 7
  max_errors      = 1
  priority        = 2
  task_arn        = "AWS-UpdateSSMAgent"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.nonproduction.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.nonprod.id]
  }
}

resource "aws_ssm_maintenance_window_task" "prodospatch" {
  name            = "bedrock-StandardPatchBaseline-Prod"
  max_concurrency = 7
  max_errors      = 1
  priority        = 3
  task_arn        = "AWS-RunPatchBaseline"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.production.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.prod.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }
      parameter {
        name   = "RebootOption"
        values = ["NoReboot"]
      }
    }
  }
}

resource "aws_ssm_maintenance_window_task" "nonprodospatch" {
  name            = "bedrock-StandardPatchBaseline-NonProd"
  max_concurrency = 7
  max_errors      = 1
  priority        = 3
  task_arn        = "AWS-RunPatchBaseline"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.nonproduction.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.nonprod.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }
      parameter {
        name   = "RebootOption"
        values = ["NoReboot"]
      }
    }
  }
}

resource "aws_ssm_maintenance_window_task" "prodcwupdate" {
  name            = "bedrock-Update-CloudWatchAgent-Prod"
  max_concurrency = 7
  max_errors      = 1
  priority        = 4
  task_arn        = "AWS-ConfigureAWSPackage"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.production.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.prod.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "action"
        values = ["Install"]
      }
      parameter {
        name   = "installationType"
        values = ["Uninstall and reinstall"]
      }
      parameter {
        name   = "name"
        values = ["AmazonCloudWatchAgent"]
      }
    }
  }
}

resource "aws_ssm_maintenance_window_task" "nonprodcwupdate" {
  name            = "bedrock-Update-CloudWatchAgent-NonProd"
  max_concurrency = 7
  max_errors      = 1
  priority        = 4
  task_arn        = "AWS-ConfigureAWSPackage"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.nonproduction.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.nonprod.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "action"
        values = ["Install"]
      }
      parameter {
        name   = "installationType"
        values = ["Uninstall and reinstall"]
      }
      parameter {
        name   = "name"
        values = ["AmazonCloudWatchAgent"]
      }
    }
  }
}
