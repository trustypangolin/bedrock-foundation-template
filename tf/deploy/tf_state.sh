#!/bin/bash
if [ -f credentials.env ]; then
  echo "========================================================================"
  echo "Found Credentials, Importing"
  export $(cat credentials.env | xargs)
  echo "========================================================================"
else
  echo "========================================================================"
  echo "Using Job defined credentials.env" 
  echo "========================================================================"
fi

# Does the customised variables file exist in the repo, or do we just grab it from secrets
if [ ! -f terraform.tfvars ]; then
  # It's in secrets probably
  echo "========================================================================"
  echo "$BEDROCK_TF_VARS" | base64 --decode > "terraform.tfvars" 
  echo "BEDROCK_TF_VARS read from secrets, decoded and pushed to terraform.tfvars file"
  echo "========================================================================"
else 
  # It's part of the repo, assume its good
  echo "========================================================================"
  echo "terraform.tfvars file part of repo"
  echo "========================================================================"
fi

# Does the remote state file setup exist in the repo, or do we grab it from secrets
if [ ! -f remote_state.tf ]; then
  # It's in secrets probably
  echo "========================================================================"
  echo "$BEDROCK_TF_STATE" | base64 --decode > "remote_state.tf"
  echo "BEDROCK_TF_STATE read from secrets, decoded and pushed to remote_state.tf file"
  echo "========================================================================"
else
  # It's part of the repo, assume its good
  echo "========================================================================"
  echo "remote_state.tf part of repo" 
  echo "========================================================================"
fi

# Check for local run, otherwise Environment value is set from CI/CD
if [ "$1" == "" ] || [ $# -gt 1 ]; then
  echo "========================================================================"
  echo "No Parameter sent, Assuming CI/CD"
  echo "ENVIRONMENT set to $ENVIRONMENT"
  echo "========================================================================"
else
  echo "========================================================================"
  ENVIRONMENT=$1
  echo "ENVIRONMENT set to $ENVIRONMENT"
  echo "========================================================================"
fi

# Now we grab the parameters, and extract the name we need
S3Bucket=$(cat terraform.tfvars | grep unique_prefix | cut -d '=' -f2 | tr -d '[:blank:]"')

# Now we grab the base region in the same way
AWSRegion=$(cat terraform.tfvars | grep region | cut -d '=' -f2 | tr -d '[:blank:]"')

# Initialise the terraform state from the extracted variables
terraform init                                     \
      -backend-config="bucket=$S3Bucket-tfstate"   \
      -backend-config="key=bedrock/${ENVIRONMENT}" \
      -backend-config="region=$AWSRegion"
