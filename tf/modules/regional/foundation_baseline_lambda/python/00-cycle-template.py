import boto3
import os
import json
# import cfnresponse


# Grab all active regions
def grab_region_list():
  regions = boto3.client('ec2').describe_regions(AllRegions=False)
  rlist = []
  for region in regions['Regions']:
    rlist.append(region['RegionName'])
  return rlist


def grab_org_list():
  role = os.environ["MGMTROLE"]
  account = os.environ["MGMTACCT"]
  sess = assume_role(account, 'sess', boto3.client('sts'), role)
  org = sess.client('organizations')
  paginator = org.get_paginator('list_accounts')
  account_list = []
  account_iterator = paginator.paginate()
  for page in account_iterator:
    for acct in page['Accounts']:
      account_list.append(acct['Id'])
  return account_list


def assume_role(account_id, session_name, sts, role):
  resp = sts.assume_role(RoleArn='arn:aws:iam::' + account_id + ':role/' + role, RoleSessionName=session_name)
  return boto3.Session(
    aws_access_key_id=resp['Credentials']['AccessKeyId'], 
    aws_secret_access_key=resp['Credentials']['SecretAccessKey'], 
    aws_session_token=resp['Credentials']['SessionToken'])


# core function to assume role and run 'something'
def core_functions(regions, accounts, role):
  for account in accounts:
    sessions = assume_role(account, 'sess', boto3.client('sts'), role)
    for region in regions:
      print('assumed', account, 'in', region, 'with', sessions)
      custom_code(sessions, region)


def handler(e, c):
  # if "ResponseURL" in e: cfnresponse.send(e, c, cfnresponse.SUCCESS, {}, '')
  print("REQUEST RECEIVED:\n" + json.dumps(e))
  if 'source' in e: print('Scheduled Event')
  if 'RequestType' in e:
    print('curl -H \'Content-Type: \'\'\' -X PUT -d \'{\n'
          '   "Status": "SUCCESS",\n'
          '   "PhysicalResourceId": "' + e['LogicalResourceId'] + '",\n'
          '   "StackId": "' + e['StackId'] + '",\n'
          '   "RequestId": "' + e['RequestId'] + '",\n'
          '   "LogicalResourceId": "' + e['LogicalResourceId'] + '"\n'
          '}\' \'' + e['ResponseURL'] + '\''
          )
  if "REGIONS" not in os.environ: regions = grab_region_list()
  else: regions = os.environ["REGIONS"].split(",")
  if "MEMBERACCT" not in os.environ: accounts = grab_org_list()
  else: accounts = os.environ["MEMBERACCT"].split(",")
  if "MEMBERROLE" not in os.environ: role = "OrganizationAccountAccessRole"
  else: role = os.environ["MEMBERROLE"]
  print("CloudFormation Initiated with variable:", regions, accounts, role)
  core_functions(regions, accounts, role)


# Custom code goes here, this runs in the accounts and regions passed in
def custom_code(s, region):
  if s == 'current':
    ec2 = boto3.client('ec2', region_name=region)
  else:
    ec2 = s.client('ec2', region_name=region)
  # do things with assumed role
  return 0

# Only required for testing locally
if __name__ == "__main__":
    handler('1', '1')