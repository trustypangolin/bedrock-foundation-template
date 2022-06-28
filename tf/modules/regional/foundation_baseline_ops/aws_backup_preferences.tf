resource "aws_backup_region_settings" "backup" {
  resource_type_opt_in_preference = {
    "Aurora"          = true
    "DynamoDB"        = true
    "EBS"             = true
    "EC2"             = true
    "EFS"             = true
    "FSx"             = true
    "RDS"             = true
    "S3"              = true
    "Storage Gateway" = true
    "DocumentDB"      = false
    "Neptune"         = false
    "VirtualMachine"  = false
  }
}
