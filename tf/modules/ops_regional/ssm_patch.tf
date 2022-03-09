resource "aws_ssm_maintenance_window" "production" {
  name              = "bedrock-AutomatedPatching-Prod"
  schedule          = "cron(0 4 ? * THU *)"
  schedule_timezone = "Australia/Brisbane"
  duration          = 3
  cutoff            = 1
}

resource "aws_ssm_maintenance_window" "nonproduction" {
  name              = "bedrock-AutomatedPatching-NonProd"
  schedule          = "cron(0 4 ? * SUN *)"
  schedule_timezone = "Australia/Brisbane"
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
