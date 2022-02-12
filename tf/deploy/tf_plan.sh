#!/bin/bash
if [ -f credentials.env ];
then
  echo "Found Credentials, Importing"
  export $(cat credentials.env | xargs)
else
  echo "Using Job defined credentials.env" 
fi

echo Validating Code
terraform validate 

echo Planning
terraform plan --out plan.json
terraform show --json plan.json | jq -r '([.resource_changes[]?.change.actions?]|flatten)|{"create":(map(select(.=="create"))|length),"update":(map(select(.=="update"))|length),"delete":(map(select(.=="delete"))|length)}' > plan
cat plan
