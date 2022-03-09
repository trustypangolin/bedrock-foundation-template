# Project Architecture
## Landing Zone Terraform Projects
A Terraform project is any directory that contains tf files and which has been initialized using the init command, which sets up Terraform caches and default local state

The following is the file/directory tree setup for the Landing Zone:
```
apac-landing-zone-template
└── terraform
    |
    # These projects relate to each AWS Account and need to be 'init'
    ├── central
    ├── logarchive
    ├── management
    ├── org
    ├── production
    └── security
 
    # This folder contains DevOps scripts accessed from CI/CD processes
    └── deploy

    # This contains terraform modules
    └── modules

    # A common set of templated terraform files
    └── common

    # These are the bootstrap terraform files
    ├── dynamodb.tf
    ├── iam-deploy-role.tf
    ├── oidc-foundation-bootstrap.tf
    ├── provider.tf
    ├── s3.tf
    ├── terraform.tfvars.template
    └── variables.tf

    # These are scripts to import existing state setups to rebaseline them
    ├── customer.sh
    └── state_import.sh
```
