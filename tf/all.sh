#!/bin/bash

cd management
terraform init
terraform apply --auto-approve
cd ..

cd security
terraform init
terraform apply --auto-approve
cd ..

cd central
terraform init
terraform apply --auto-approve
cd ..

cd production
terraform init
terraform apply --auto-approve

cd ..
