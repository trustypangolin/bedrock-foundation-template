#!/bin/bash

cd management
terraform init
terraform apply --auto-approve
cd ..

cd security
terraform init
terraform apply --auto-approve
cd ..

cd shared
terraform init
terraform apply --auto-approve
cd ..

cd production
terraform init
terraform apply --auto-approve

cd ..
