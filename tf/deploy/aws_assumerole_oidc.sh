#!/bin/bash

if git remote -v | grep -E 'origin.*push|fetch.*gitlab' 2>/dev/null; then
  echo "found gitlab remote fetch"
  jwt_token=$CI_JOB_JWT_V2
  session_name="GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
  role_name=GitLab-Bootstrap
else
  echo "found something else, not gitlab"
fi

# Assume the Role that trusts the OIDC IdP using Web Identity
STS=($(aws sts assume-role-with-web-identity                          \
--role-arn arn:aws:iam::${AWS_ROOT_ACCOUNT}:role/${role_name}         \
--role-session-name "${session_name}"                                 \
--web-identity-token $jwt_token                                       \
--duration-seconds 3600                                               \
--query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'      \
--output text))
export AWS_ACCESS_KEY_ID="${STS[0]}"      
export AWS_SECRET_ACCESS_KEY="${STS[1]}"  
export AWS_SESSION_TOKEN="${STS[2]}"      

# Using the Web Identity, Now assume the role that has actual permissions
STSADMIN=($(aws sts assume-role                                     \
  --role-arn arn:aws:iam::${AWS_ROOT_ACCOUNT}:role/bedrock-deploy   \
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
