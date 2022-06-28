resource "aws_ecs_cluster" "cluster" {
  name = var.cluster
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = ["FARGATE_SPOT", "FARGATE"]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

module "security_group" {
  source = "gitlab.com/douughlabs/douugh-terraform-modules/aws//regional/security_group"
  name   = format("%s_ecs_%s", var.env, var.instance_group)
  env    = var.env
  vpc_id = var.vpc.vpc_id
}

resource "aws_security_group_rule" "task_task" {
  type              = "ingress"
  description       = "Task to Task Self"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  self              = true
  security_group_id = module.security_group.security_group_id
}
