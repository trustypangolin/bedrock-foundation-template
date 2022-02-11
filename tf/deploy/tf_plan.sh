#!/bin/bash

echo Validating Code
terraform validate 

echo Planning
terraform plan --out plan