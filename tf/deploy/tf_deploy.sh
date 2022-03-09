#!/bin/bash
if [ -f credentials.env ];
then
  echo "Found Credentials, Importing"
  export $(cat credentials.env | xargs)
else
  echo "Using Job defined credentials.env" 
fi

terraform apply --auto-approve -compact-warnings