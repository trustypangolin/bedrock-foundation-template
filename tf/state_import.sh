#!/bin/bash

# Terraform Imports for existing S3 buckets, DynamoDB, and Role
S3_BUCKET="indigocapybara-tfstate"
DYNAMODB="bedrock-tfstate" 
TFROLE="bedrock-deploy"
ACCOUNTID=$1

terraform import aws_dynamodb_table.terraform                               ${DYNAMODB}
terraform import aws_iam_role.bedrock                                       ${TFROLE}
terraform import aws_s3_bucket.tfstate                                      ${S3_BUCKET}
terraform import aws_s3_bucket_acl.tfstate                                  ${S3_BUCKET}
terraform import aws_s3_bucket_lifecycle_configuration.tfstate              ${S3_BUCKET}
terraform import aws_s3_bucket_policy.tfstate                               ${S3_BUCKET}
terraform import aws_s3_bucket_public_access_block.tfstate                  ${S3_BUCKET}
terraform import aws_s3_bucket_server_side_encryption_configuration.tfstate ${S3_BUCKET}
terraform import aws_s3_bucket_versioning.tfstate                           ${S3_BUCKET}
terraform import aws_iam_role.foundation_oidc                               "foundation-terraform-oidc"
terraform import aws_iam_role.tf_state                                      "foundation-tf-state"

terraform import 'aws_iam_openid_connect_provider.github[0]' arn:aws:iam::${ACCOUNTID}:oidc-provider/token.actions.githubusercontent.com
terraform import 'aws_iam_openid_connect_provider.gitlab[0]' arn:aws:iam::${ACCOUNTID}:oidc-provider/gitlab.com
terraform import 'aws_iam_openid_connect_provider.bitbucket[0]' arn:aws:iam::${ACCOUNTID}:oidc-provider/api.bitbucket.org/2.0/workspaces/workspacenamehere/pipelines-config/identity/oidc
