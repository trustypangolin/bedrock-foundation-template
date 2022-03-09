# Tools (Fargate)
resource "aws_ecs_task_definition" "taskdef-tools" {
  family                   = format("%s-tools", var.env)
  container_definitions    = var.task_definition_tools
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn = aws_iam_role.ecs_tools_task.arn
  task_role_arn      = aws_iam_role.ecs_tools_task.arn

  volume {
    name = "service-storage"
    efs_volume_configuration {
      file_system_id = var.efs_id
      root_directory = "/traefik"
    }
  }
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

resource "aws_ecs_task_definition" "taskdef-web" {
  family                   = format("%s-web", var.env)
  container_definitions    = var.task_definition_web
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  execution_role_arn = aws_iam_role.ecs_tools_task.arn
  task_role_arn      = aws_iam_role.ecs_tools_task.arn

  volume {
    name = "service-storage"
    efs_volume_configuration {
      file_system_id = var.efs_id
      root_directory = "/vault"
    }
  }
  lifecycle {
    ignore_changes = [container_definitions]
  }
}
