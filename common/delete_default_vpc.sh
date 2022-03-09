#!/bin/bash

if [[ $1 = "" ]]; then
  DRYRUN="--dry-run"
fi

if [[ $1 = "APPLY" ]]; then
  DRYRUN=""
fi

#iterate all the regions, and populate the files
aws ec2 describe-regions | jq -r '.Regions[].RegionName' | while read -r region; do
  VPCID=$(aws ec2 describe-vpcs --region $region | jq -r '.Vpcs[] | select(.IsDefault == true) | .VpcId')
# Find Resources in the default VPC
  FindResourceEC2=$(aws ec2 describe-instances                --region $region --filters "Name=vpc-id,Values='$VPCID'"                    | jq -r '.[]    | select(length > 0)'  )
  FindResourceNI=$(aws ec2 describe-network-interfaces       --region $region --filters "Name=vpc-id,Values='$VPCID'"                     | jq -r '.[]    | select(length > 0)' )
  FindResourceEP=$(aws ec2 describe-vpc-endpoints            --region $region --filters "Name=vpc-id,Values='$VPCID'"                     | jq -r '.[]    | select(length > 0)'     )
  FindResourcePC=$(aws ec2 describe-vpc-peering-connections  --region $region --filters "Name=requester-vpc-info.vpc-id,Values='$VPCID'"  | jq -r '.[]    | select(length > 0)'   )
  FindResourceVPN=$(aws ec2 describe-vpn-connections          --region $region --filters "Name=vpc-id,Values='$VPCID'"                    | jq -r '.[]    | select(length > 0)'      )
  FindResourceVPG=$(aws ec2 describe-vpn-gateways             --region $region --filters "Name=attachment.vpc-id,Values='$VPCID'"         | jq -r '.[]    | select(length > 0)'   )
  FindResourceSG=$(aws ec2 describe-security-groups          --region $region --filters "Name=vpc-id,Values='$VPCID'"                     | jq -r '.SecurityGroups[] | if .GroupName != "default" then .GroupId else empty end | select(length > 0)' )
  FindResourceNG=$(aws ec2 describe-nat-gateways             --region $region --filter  "Name=vpc-id,Values='$VPCID'"                     | jq -r '.[]    | select(length > 0)'       )

# Find Default VPC Resources
  FindResourceIG=$(aws ec2 describe-internet-gateways        --region $region --filters "Name=attachment.vpc-id,Values='$VPCID'"          | jq -r '.InternetGateways[].InternetGatewayId | select(length > 0)' )
  FindResourceSB=$(aws ec2 describe-subnets                  --region $region --filters "Name=vpc-id,Values='$VPCID'"                     | jq -r '.Subnets[].SubnetId | select(length > 0)'   )
  FindResourceRT=$(aws ec2 describe-route-tables             --region $region --filters "Name=vpc-id,Values='$VPCID'"                     | jq -r '.RouteTables[].RouteTableId | select(length > 0)' )
  FindResourceACL=$(aws ec2 describe-network-acls             --region $region --filters "Name=vpc-id,Values='$VPCID'"                    | jq -r '.NetworkAcls[].NetworkAclId | select(length > 0)'    )

  RESOURCE="FOUND"
  if [ "$FindResourceEC2" = "" ]; then echo "no EC2";                 RESOURCE="NONE" ; else echo "Found EC2"; RESOURCE="FOUND"; fi
  if [ "$FindResourceNI"  = "" ]; then echo "no Network Attachments"; RESOURCE="NONE" ; else echo "Found EC2";RESOURCE="FOUND"; fi
  if [ "$FindResourceEP" = "" ];  then echo "no VPC Endpoints";       RESOURCE="NONE" ; else echo "Found EC2";RESOURCE="FOUND"; fi
  if [ "$FindResourcePC" = "" ];  then echo "no Peering";             RESOURCE="NONE" ; else echo "Found EC2";RESOURCE="FOUND"; fi
  if [ "$FindResourceVPN" = "" ]; then echo "no VPN";                 RESOURCE="NONE" ; else echo "Found EC2";RESOURCE="FOUND"; fi
  if [ "$FindResourceVPG" = "" ]; then echo "no VPG";                 RESOURCE="NONE" ; else echo "Found EC2";RESOURCE="FOUND"; fi
  if [ "$FindResourceSG"  = "" ]; then echo "no Custom SG";           RESOURCE="NONE" ; else echo "Found SG";RESOURCE="FOUND"; fi
  if [ "$FindResourceNG" = "" ]; then echo "no NAT Gateway";          RESOURCE="NONE" ; else echo "Found NAT";RESOURCE="FOUND"; fi

# Non Critical, these are defaults that can be removed  only if the resources above dont exist
  if [ "$FindResourceIG" = "" ]; then echo "no Internet Gateway";  RESOURCE="NONE" ; else echo "Found IG"; fi
  if [ "$FindResourceSB" = "" ]; then echo "no Subnets";           RESOURCE="NONE" ; else echo "Found Subnets"; fi
  if [ "$FindResourceRT" = "" ]; then echo "no Route Tables";      RESOURCE="NONE" ; else echo "Found Route Tables"; fi
  if [ "$FindResourceACL" = "" ]; then echo "no NACL";             RESOURCE="NONE" ; else echo "Found NACLs"; fi

# If only default resources, remove then
  if [ "$RESOURCE" = "NONE" ]; then
    echo "Processing $region"

    if [ "$FindResourceSG" = "" ]; then 
      echo "no SG"
    else
      echo "Remove Subnets"
      aws ec2 describe-subnets --region $region | jq -r '.Subnets[].SubnetId' | while read -r subnet; do
        aws ec2 delete-subnet --region $region $DRYRUN --subnet-id $subnet
      done
    fi

    if [ "$FindResourceIG" = "" ]; then 
      echo "no IG"
    else
      echo "Remove Internet Gateway"
      aws ec2 detach-internet-gateway --region $region $DRYRUN --internet-gateway-id $FindResourceIG --vpc-id $VPCID
      aws ec2 delete-internet-gateway --region $region $DRYRUN --internet-gateway-id $FindResourceIG
    fi

    if [ "$VPCID" = ""  ]; then
      echo "No VPC"
    else
      echo "Remove VPC"
      aws ec2 delete-vpc --region $region $DRYRUN --vpc-id $VPCID
    fi
  fi
done
