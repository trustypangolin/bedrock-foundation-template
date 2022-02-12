#!/bin/bash
if [ -f credentials.env ];
then
  echo "Found Credentials, Importing"
  export $(cat credentials.env | xargs)
else
  echo "Using Job defined credentials.env" 
fi

while getopts t: flag
do
    case "${flag}" in
        t) target=${OPTARG};;
    esac
done

if [ "$target" == "org" ]; then
  echo -e "coming from org, setting target to management"
  target="management"
  echo "Target: $target"
  targetacc=${AWS_ROOT_ACCOUNT}
else
  echo "Target: $target"
  targetacc=$(cat outputs.json | jq  '.acc.value | with_entries( .key |= ascii_downcase ) ' | grep $target | cut -d : -f2 | tr -d '[:blank:]\",' )
fi

echo $targetacc

# Using the Web Identity, Now assume the role that has actual permissions
STSADMIN=($(aws sts assume-role                                     \
  --role-arn arn:aws:iam::${targetacc}:role/bedrock-deploy          \
  --role-session-name "Admin-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"    \
  --duration-seconds 3600                                           \
  --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'  \
  --output text))
if [ ! -f terraform.tfvars ]; then cat "$BEDROCK_TF_VARS" > "terraform.tfvars"; else echo "tfvars part of repo"; fi

# Send these credentials to the .env file as an artifact for subsequent jobs
echo "AWS_DEFAULT_REGION=$(cat terraform.tfvars | grep base_region | cut -d = -f2 | tr -d '[:blank:]\"')" > credentials.env
echo "AWS_ACCESS_KEY_ID=${STSADMIN[0]}" >> credentials.env
echo "AWS_SECRET_ACCESS_KEY=${STSADMIN[1]}" >> credentials.env
echo "AWS_SESSION_TOKEN=${STSADMIN[2]}" >> credentials.env
