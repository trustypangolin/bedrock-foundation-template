resource "aws_kms_key" "security_cmk" {
  description             = "For Security S3 Bucket"
  deletion_window_in_days = 30
  multi_region            = true
  policy                  = data.aws_iam_policy_document.security_cmk.json
}

data "aws_iam_policy_document" "security_cmk" {
  # Default Root account access, DO NOT REMOVE
  statement {
    sid       = "Enable Root Permissions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)]
    }
  }

  # Allow Accounts in the Org general access to the Key
  statement {
    sid       = "Allow use of the key"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:CreateGrant",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ListGrants",
      "kms:ReEncrypt*",
      "kms:RevokeGrant",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.terraform_remote_state.org.outputs.org_id]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  # AWS Config Service Role access
  statement {
    sid       = "AWSConfigKMSPolicyService"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSConfigKMSPolicyIAM"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]
    principals {
      type        = "AWS"
      identifiers = data.terraform_remote_state.org.outputs.all_accounts_ids
    }
  }

  # Flow Logs Access
  statement {
    sid       = "Allow VPC Flow Logs to use the key"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }

  # CloudTrail
  statement {
    sid       = "Allow CloudTrail to encrypt logs"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:GenerateDataKey*", "kms:DescribeKey"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_kms_alias" "security_cmk" {
  name          = "alias/security"
  target_key_id = aws_kms_key.security_cmk.key_id
}

# {
#     "Version": "2012-10-17",
#     "Statement": [

#         {
#             "Sid": "Allow_CloudWatch_for_CMK",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "cloudwatch.amazonaws.com"
#             },
#             "Action": [
#                 "kms:GenerateDataKey*",
#                 "kms:Decrypt"
#             ],
#             "Resource": "*"
#         },

#         {
#             "Sid": "Allow CloudTrail to encrypt logs",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "cloudtrail.amazonaws.com"
#             },
#             "Action": "kms:GenerateDataKey*",
#             "Resource": "*",
#             "Condition": {
#                 "StringLike": {
#                     "kms:EncryptionContext:aws:cloudtrail:arn": [
#                         "arn:aws:cloudtrail:*:610296856422:trail/*",
#                         "arn:aws:cloudtrail:*:214583867836:trail/*",
#                         "arn:aws:cloudtrail:*:978137175178:trail/*",
#                         "arn:aws:cloudtrail:*:753624670575:trail/*"
#                     ]
#                 }
#             }
#         },
#         {
#             "Sid": "Allow CloudTrail to describe key",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "cloudtrail.amazonaws.com"
#             },
#             "Action": "kms:DescribeKey",
#             "Resource": "*"
#         },
#         {
#             "Sid": "Allow principals in the account to decrypt log files",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "*"
#             },
#             "Action": [
#                 "kms:ReEncryptFrom",
#                 "kms:Decrypt"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "StringEquals": {
#                     "kms:CallerAccount": [
#                         "610296856422",
#                         "214583867836",
#                         "978137175178",
#                         "753624670575"
#                     ]
#                 },
#                 "StringLike": {
#                     "kms:EncryptionContext:aws:cloudtrail:arn": [
#                         "arn:aws:cloudtrail:*:610296856422:trail/*",
#                         "arn:aws:cloudtrail:*:214583867836:trail/*",
#                         "arn:aws:cloudtrail:*:978137175178:trail/*",
#                         "arn:aws:cloudtrail:*:753624670575:trail/*"
#                     ]
#                 }
#             }
#         },


#  {
#         "Sid": "AWSConfigBucketDelivery",
#         "Effect": "Allow",
#         "Principal": {
#             "Service": "config.amazonaws.com"
#         },
#         "Action": "s3:PutObject",
#         "Resource": [
#             "arn:aws:s3:::bedrockdemo-config/AWSLogs/545116206458/Config/*",
#             "arn:aws:s3:::bedrockdemo-config/AWSLogs/286309576947/Config/*",
#             "arn:aws:s3:::bedrockdemo-config/AWSLogs/820219544003/Config/*",
#             "arn:aws:s3:::bedrockdemo-config/AWSLogs/347493294681/Config/*"
#         ],
#         "Condition": {
#             "StringEquals": {
#                 "s3:x-amz-acl": "bucket-owner-full-control"
#             }
#         }
#     },

# S3 related resources
# data "aws_iam_policy_document" "hello" {
#   statement {
#     sid       = "Allow access for Key Administrators"
#     effect    = "Allow"
#     resources = ["*"]
#     actions = [
#       "kms:Create*",
#       "kms:Describe*",
#       "kms:Enable*",
#       "kms:List*",
#       "kms:Put*",
#       "kms:Update*",
#       "kms:Revoke*",
#       "kms:Disable*",
#       "kms:Get*",
#       "kms:Delete*",
#       "kms:TagResource",
#       "kms:UntagResource",
#       "kms:ScheduleKeyDeletion",
#       "kms:CancelKeyDeletion",
#       "kms:ReplicateKey",
#       "kms:UpdatePrimaryRegion",
#     ]

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${module.audit_account.account_id}:role/aws-service-role/cloudtrail.amazonaws.com/AWSServiceRoleForCloudTrail"]
#     }
#   }
# }
