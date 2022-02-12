#!/bin/bash
if [ -f credentials.env ];
then
  echo "Found Credentials, Importing"
  export $(cat credentials.env | xargs)
else
  echo "Using Job defined credentials.env" 
fi

# Does the customised variables file exist in the repo, or do we just grab it from secrets
if [ ! -f terraform.tfvars ]; 
then 
  # It's in secrets probably
  cat "$BEDROCK_TF_VARS" > "terraform.tfvars"; 
else 
  # It's part of the repo, assume its good
  echo "tfvars part of repo"; 
fi

# Does the remote state file setup exist in the repo, or do we grab it from secrets
if [ ! -f remote_state.tf ]; 
then
  # It's in secrets probably
  cat "$BEDROCK_TF_STATE" > "remote_state.tf"; 
else
  # It's part of the repo, assume its good
  echo "remote_state.tf part of repo"; 
fi

# Now we grab the parameters, and just extract the name we need
export S3Bucket=$(cat terraform.tfvars | grep unique_prefix | cut -d = -f2 | tr -d '[:blank:]"')

terraform init                                    \
      -backend-config="bucket=$S3Bucket-tfstate"  \
      -backend-config="key=${ENVIRONMENT}"
