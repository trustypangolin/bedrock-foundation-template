output "efs" {
  value = {
    "efs_id" = aws_efs_file_system.tools.id,
    "mount"  = aws_efs_mount_target.tools.*.id
  }
}
