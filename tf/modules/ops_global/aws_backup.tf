data "aws_iam_policy_document" "awsbackup" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "backup_role_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup_role.name
}

resource "aws_iam_role_policy_attachment" "restore_role_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.aws_backup_role.name
}

resource "aws_iam_role" "aws_backup_role" {
  name               = "AWSBackup"
  assume_role_policy = data.aws_iam_policy_document.awsbackup.json
}

