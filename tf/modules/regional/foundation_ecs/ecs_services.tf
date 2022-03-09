# Tools Fargate
resource "aws_ecs_service" "ecs-service-tools" {
  name                               = format("ecs-service-%s-tools", var.env)
  cluster                            = aws_ecs_cluster.cluster.id
  task_definition                    = format("%s:%s", aws_ecs_task_definition.taskdef-tools.family, aws_ecs_task_definition.taskdef-tools.revision)
  desired_count                      = var.desired_tools_containers
  deployment_minimum_healthy_percent = 0
  enable_execute_command             = true
  propagate_tags                     = "SERVICE"
  network_configuration {
    assign_public_ip = true
    security_groups = [
      module.security_group.security_group_id,
    ]
    subnets = var.vpc.public.subnet_ids
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
  }
}

resource "aws_ecs_service" "ecs-service-web" {
  name                               = format("ecs-service-%s-web", var.env)
  cluster                            = aws_ecs_cluster.cluster.id
  task_definition                    = format("%s:%s", aws_ecs_task_definition.taskdef-web.family, aws_ecs_task_definition.taskdef-web.revision)
  desired_count                      = var.desired_web_containers
  deployment_minimum_healthy_percent = 0

  propagate_tags = "SERVICE"
  network_configuration {
    assign_public_ip = true
    security_groups = [
      module.security_group.security_group_id,
    ]
    subnets = var.vpc.private.subnet_ids
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
  }
}
