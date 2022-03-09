module "security_group" {
  source = "../security_group"
  name   = format("%s_efs_%s", var.env, var.instance_group)
  env    = var.env
  vpc_id = var.vpc.vpc_id
}

resource "aws_security_group_rule" "task_task" {
  type              = "ingress"
  description       = "Access EFS"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [var.vpc.cidr]
  security_group_id = module.security_group.security_group_id
}

resource "aws_efs_file_system" "tools" {
  encrypted = true
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
  tags = {
    "Name" = "tools"
  }
}

resource "aws_efs_mount_target" "tools" {
  count           = length(var.vpc.private.subnet_ids)
  file_system_id  = aws_efs_file_system.tools.id
  subnet_id       = var.vpc.private.subnet_ids[count.index]
  security_groups = [module.security_group.security_group_id]
}

data "aws_security_group" "tools" {
  id = module.security_group.security_group_id
}

data "aws_subnet" "tools" {
  id = var.vpc.private.subnet_ids[0]
}

resource "aws_datasync_location_efs" "tools" {
  efs_file_system_arn = aws_efs_mount_target.tools[0].file_system_arn
  ec2_config {
    security_group_arns = [data.aws_security_group.tools.arn]
    subnet_arn          = data.aws_subnet.tools.arn
  }
  subdirectory = "/traefik"
}

resource "aws_datasync_location_efs" "web" {
  efs_file_system_arn = aws_efs_mount_target.tools[0].file_system_arn
  ec2_config {
    security_group_arns = [data.aws_security_group.tools.arn]
    subnet_arn          = data.aws_subnet.tools.arn

  }
  subdirectory = "/vault"
}

resource "aws_s3_bucket" "tools" {
  bucket = format("%s-tools-%s", var.unique_prefix, var.env)
}

resource "aws_s3_bucket_public_access_block" "tools" {
  bucket                  = aws_s3_bucket.tools.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tools" {
  bucket = aws_s3_bucket.tools.bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_datasync_location_s3" "tools" {
  s3_bucket_arn = aws_s3_bucket.tools.arn
  subdirectory  = "/traefik"

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync.arn
  }
}

resource "aws_datasync_location_s3" "web" {
  s3_bucket_arn = aws_s3_bucket.tools.arn
  subdirectory  = "/vault"

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync.arn
  }
}

resource "aws_datasync_task" "tos3_traefik" {
  source_location_arn      = aws_datasync_location_efs.tools.arn
  destination_location_arn = aws_datasync_location_s3.tools.arn
  name                     = "Backup to S3 Traefik"

  options {
    bytes_per_second = -1
  }

  schedule {
    schedule_expression = "cron(0 0 ? * SAT *)"
  }
}

resource "aws_datasync_task" "toefs_traefik" {
  source_location_arn      = aws_datasync_location_s3.tools.arn
  destination_location_arn = aws_datasync_location_efs.tools.arn
  name                     = "Restore to EFS Traefik"

  options {
    bytes_per_second = -1
  }
}

resource "aws_datasync_task" "tos3_vault" {
  source_location_arn      = aws_datasync_location_efs.web.arn
  destination_location_arn = aws_datasync_location_s3.web.arn
  name                     = "Backup to S3 Vault"

  options {
    bytes_per_second = -1
  }

  schedule {
    schedule_expression = "cron(0 0 ? * SUN *)"
  }
}

resource "aws_datasync_task" "toefs_vault" {
  source_location_arn      = aws_datasync_location_s3.web.arn
  destination_location_arn = aws_datasync_location_efs.web.arn
  name                     = "Restore to EFS Vault"

  options {
    bytes_per_second = -1
  }
}
