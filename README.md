# bedrock-landing-zone


# Bootstrap Instructions
awsume / set AWS_PROFILE to your temp IAM admin/SSO user in the managment account
set the variables for your CI/CD providers. 

# Bootstrap the State S3 and DynamoDB

> cd tf
> terraform init
> terraform apply


# AWS Organization State
> cd org                                                              # begin the org setup
> ../deploy/tf_state.sh org                                           # initialise the state s3 bucket, and org object
> terraform import aws_organizations_organization.org r-xxxx          # The id of the root Organization, should be active as part of initial SSO
> terraform import aws_s3_bucket.tfstate <unique_prefix>_tfstate      # Org will maintain the state going forward
> terraform import aws_dynamodb_table.terraform bedrock-tfstate       # Org will maintain the state going forward

> terraform apply                                                     # This is enough now to bootstrap the Org with SSO and Org services

# CICD
The system is now ready for CI/CD going forward

# Manual
terraform can be applied manually for each account by initialising each folder. eg the security account is the first account to provision

copy/create the terraform.tfvars and remote_state.tf from the templates.

> cd security                          # managment account
> ../deploy/tf_state.sh security      # managment state object
> terraform apply                     # apply management terraform

