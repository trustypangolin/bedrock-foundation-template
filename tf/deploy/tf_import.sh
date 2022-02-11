#!/bin/bash

echo "Checking AWS for existing resources - Organization"
echo orgid=$(aws organizations describe-organization | jq .Organization.Id | tr -d '"') > org.env
orgid=$(aws organizations describe-organization | jq .Organization.Id | tr -d '"')

echo "Checking AWS for existing resources - Dynamodb Locking Table"
echo dynamodb=$(aws dynamodb list-tables | grep "tfstate" | tr -d '[:blank:]"') >> org.env
dynamodb=$(aws dynamodb list-tables | grep "tfstate" | tr -d '[:blank:]"')

echo "Checking AWS for existing resources - S3 State"
echo s3=$(aws s3api list-buckets | grep "tfstate" | cut -d : -f2 | tr -d '[:blank:]\",') >> org.env
s3=$(aws s3api list-buckets | grep "tfstate" | cut -d : -f2 | tr -d '[:blank:]\",')

if terraform state show 'aws_organizations_organization.org' 2>/dev/null; then
  echo -e "org state already imported"
else
  echo -e "Importing org into state"
  terraform import aws_organizations_organization.org $orgid
fi

if terraform state show 'aws_s3_bucket.tfstate' 2>/dev/null; then
  echo -e "s3 state already imported"
else
  echo -e "Importing s3 into state"
  terraform import aws_s3_bucket.tfstate $s3
fi

if terraform state show 'aws_s3_bucket_public_access_block.tfstate' 2>/dev/null; then
  echo -e "s3 state already imported"
else
  echo -e "Importing s3 into state"
  terraform import aws_s3_bucket_public_access_block.tfstate $s3
fi

if terraform state show 'aws_s3_bucket_policy.tfstate' 2>/dev/null; then
  echo -e "s3 state already imported"
else
  echo -e "Importing s3 into state"
  terraform import aws_s3_bucket_policy.tfstate $s3
fi

if terraform state show 'aws_dynamodb_table.terraform' 2>/dev/null; then
  echo -e "dynamodb state already imported"
else
  echo -e "Importing dynamodb into state"
  terraform import aws_dynamodb_table.terraform $dynamodb
fi
cat org.env