resource "aws_organizations_policy_attachment" "denyrootkeys" {
  policy_id = aws_organizations_policy.deny_root_keys.id
  target_id = data.aws_organizations_organization.org.roots[0].id
}

// resource "aws_organizations_policy_attachment" "stopchanges" {
//   policy_id = aws_organizations_policy.stop_changes.id
//   target_id = data.terraform_remote_state.org.outputs.org_root.id
// }

# resource "aws_organizations_policy_attachment" "denys3del" {
#   policy_id = aws_organizations_policy.deny_del_s3.id
#   target_id = data.terraform_remote_state.org.outputs.security.id
# }

// Optional SCP attachment - This limits regions, but shows how it can be done. SCP is still created, but not attached
// resource "aws_organizations_policy_attachment" "limitregion" {
//   policy_id = aws_organizations_policy.limit_region.id
//   target_id = data.terraform_remote_state.org.outputs.<a dev ou export>.id
// }

resource "aws_organizations_policy" "deny_del_s3" {
  name        = "Lock_Down_Audit_S3_Deletes"
  description = "Deny s3 objects and buckets from being deleted"
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
  content     = <<CONTENT
{
    "Version":"2012-10-17",
    "Id":"LockDownAuditBuckets",
    "Statement": [
      {
        "Sid":"ProtectAuditLogs",
        "Effect":"Deny",
        "Action": [
            "s3:DeleteObject",
            "s3:DeleteObjectVersion",
            "s3:DeleteBucketPolicy",
            "s3:DeleteBucket"
        ],
        "Resource": [
            "*"
        ]
      }
    ]
}
CONTENT
}

resource "aws_organizations_policy" "deny_root_keys" {
  name        = "Deny_Root_keys"
  description = "Deny Root Keys from being created"
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
  content     = <<CONTENT
{
  "Version": "2012-10-17",
  "Id": "LockDownRootKeys",
  "Statement": [
    {
      "Condition": {
        "StringLike": {
          "aws:PrincipalArn": [
            "arn:aws:iam::*:root"
          ]
        }
      },
      "Action": "iam:CreateAccessKey",
      "Resource": [
        "*"
      ],
      "Effect": "Deny",
      "Sid": "GRRESTRICTROOTUSERACCESSKEYS"
    }
  ]
}
CONTENT
}

resource "aws_organizations_policy" "stop_changes" {
  name        = "Deny_Org_Changes"
  description = "Stop changes to CloudTrail, Leaving Orgs, and Removing Config"
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
  content     = <<CONTENT
{
    "Version":"2012-10-17",
    "Id":"LockDownCloudTrailConfig",
    "Statement": [
      {
        "Sid":"ProtectCloudTrail",
        "Effect":"Deny",
        "Action": [
            "cloudtrail:DeleteTrail",
            "cloudtrail:StopLogging",
            "cloudtrail:UpdateTrail"
        ],
        "Resource": [
            "*"
        ]
      },
      {
        "Sid":"DenyLeaveOrganisations",
        "Effect":"Deny",
        "Action": [
            "organizations:LeaveOrganization"
        ],
        "Resource": [
            "*"
        ]
      },
      {
        "Sid": "ProtectConfig",
        "Effect":"Deny",
        "Action": [
            "config:DeleteConfigurationRecorder",
            "config:StopConfigurationRecorder"
        ],
        "Resource": [
            "*"
        ]
      }
    ]
}
CONTENT
}

resource "aws_organizations_policy" "limit_region" {
  name        = "Deny_Unused_Regions"
  description = "Limit what Regions resources can be applied in"
  type        = "SERVICE_CONTROL_POLICY"
  tags        = var.tags
  content     = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllOutsideAllowedRegions",
      "Effect": "Deny",
      "NotAction": [
        "iam:*",
        "organizations:*",
        "route53:*",
        "budgets:*",
        "waf:*",
        "cloudfront:*",
        "globalaccelerator:*",
        "importexport:*",
        "support:*",
        "aws-portal:*",
        "account:*",
        "sts:*",
        "cur:*",
        "ce:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "ap-southeast-2",
            "us-east-2",
            "eu-west-2"
          ]
        }
      }
    }
  ]
}
CONTENT
}
