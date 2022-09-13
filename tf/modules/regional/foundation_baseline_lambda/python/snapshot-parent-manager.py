import boto3
import os
import json
# import cfnresponse

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
  resp = sts.assume_role(RoleArn='arn:aws:iam::' + account_id + ':role/' + role,
                        RoleSessionName=session_name)
  return boto3.Session(aws_access_key_id=resp['Credentials']['AccessKeyId'],
                      aws_secret_access_key=resp['Credentials']['SecretAccessKey'],
                      aws_session_token=resp['Credentials']['SessionToken'])

def core_functions(regions, accounts, role):
  for account in accounts:
    sessions = assume_role(account, 'sess', boto3.client('sts'), role)
    for region in regions:
      print('assumed', account, 'in', region, 'with', sessions)
      snapshot_parent_manager(sessions, region)

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

def snapshot_parent_manager(s, region):
  sqs = boto3.client('sqs')
  queue_url = os.environ['ENV_SQSQUEUE']
  if s == 'current':
    sess = boto3.resource('ec2', region_name=region)
    sts = boto3.client('sts')
  else:
    sess = s.resource('ec2', region_name=region)
    sts = s.client('sts')

  snapshots = sess.snapshots.filter(OwnerIds=['self'])
  account = sts.get_caller_identity().get('Account')

  for sl in snapshots:
    response = sqs.send_message(
      QueueUrl=queue_url,
      DelaySeconds=0,
      MessageBody=json.dumps({'account': account, 'region': region, 'snapshot': sl.id}),
      )

# Only required for testing locally
if __name__ == "__main__":
  # handler({
  #       "RequestType": "Create",
  #       "ResponseURL": "http://pre-signed-S3-url-for-response",
  #       "StackId": "arn:aws:cloudformation:ap-southeast-2:123456789012:stack/MyStack/guid",
  #       "RequestId": "unique id for this create request",
  #       "ResourceType": "Custom::TestResource",
  #       "LogicalResourceId": "MyTestResource",
  #       "ResourceProperties": {
  #         "StackName": "MyStack",
  #         "List": [
  #           "1",
  #           "2",
  #           "3"
  #         ]
  #       }
  #     }, '1')

  handler({
    "id": "cdc73f9d-aea9-11e3-9d5a-835b769c0d9c",
    "detail-type": "Scheduled Event",
    "source": "aws.events",
    "account": "123456789012",
    "time": "1970-01-01T00:00:00Z",
    "region": "ap-southeast-2",
    "resources": [
      "arn:aws:events:ap-southeast-2:123456789012:rule/ExampleRule"
    ],
    "detail": {}
  }, '1')
