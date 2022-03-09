#!/bin/bash
if [ -f credentials.env ];
then
  echo "Found Credentials, Importing"
  export $(cat credentials.env | xargs)
else
  echo "Using Job defined credentials.env" 
fi

# Look at the folder, and extract the account name, must match folder name (case-insensitive)
echo "account name : $(pwd | rev | cut -d"/" -f1 | rev)"
AccName=$(pwd | rev | cut -d"/" -f1 | rev)
AccNum=$(terraform state show data.terraform_remote_state.org | grep -m1 -i $AccName | cut -d'=' -f2 | tr -d '[:blank:]"')

echo "Assuming $AccName:role/bedrock-terraform and retrieving values"
sts=$(aws sts assume-role \
  --role-arn "arn:aws:iam::$AccNum:role/bedrock-terraform" \
  --role-session-name "bedrock-$AccName-import" \
  --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
  --output text)
sts=($sts)
echo "AWS_ACCESS_KEY_ID is ${sts[0]}"
aws configure set aws_access_key_id ${sts[0]} --profile $AccName
aws configure set aws_secret_access_key ${sts[1]} --profile $AccName
aws configure set aws_session_token ${sts[2]} --profile $AccName

echo "Checking AWS for existing resources - Service Linked Roles - AWS Config Multi-Account"
echo slrconfigm=$(aws iam list-roles --profile $AccName | jq -r '.Roles[] | select(.RoleName|match("AWSServiceRoleForConfigMultiAccountSetup")) | .Arn') > slr.env
slrconfigm=$(aws iam list-roles --profile $AccName | jq -r '.Roles[] | select(.RoleName|match("AWSServiceRoleForConfigMultiAccountSetup")) | .Arn')

echo "Checking AWS for existing resources - Service Linked Roles - AWS Config Single-Account"
echo slrconfig=$(aws iam list-roles --profile $AccName | jq -r '.Roles[] | select(.Arn|match("config.amazonaws.com")) | .Arn') >> slr.env
slrconfig=$(aws iam list-roles --profile $AccName | jq -r '.Roles[] | select(.Arn|match("config.amazonaws.com")) | .Arn')
aws iam list-roles --profile $AccName | jq -r '.Roles[] | select(.Arn|match("config.amazonaws.com")) | .Arn'

# Import the existing Service Linked Roles
# if terraform state show 'module.modules_all_global.aws_iam_service_linked_role.multi_acc_config' 2>/dev/null; then
#   echo -e "Service Linked Roles - Config Multi Account - state already imported"
# else
#   echo -e "Importing Service Linked Roles - Config Multi Account into state"
#   terraform import module.modules_all_global.aws_iam_service_linked_role.multi_acc_config $slrconfigm
# fi

# if terraform state show 'module.modules_all_global.aws_iam_service_linked_role.config' 2>/dev/null; then
#   echo -e "Service Linked Roles - Config Service - state already imported"
# else
#   echo -e "Importing Service Linked Roles - Config Service into state"
#   terraform import module.modules_all_global.aws_iam_service_linked_role.config $slrconfig
# fi
