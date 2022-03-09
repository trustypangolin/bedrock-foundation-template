import boto3
import os
import json
# import cfnresponse
import ast
from datetime import datetime

BUILD_VERSION = '1.1.3'
SERVICE_ACCOUNT_NAME = os.environ['IAM_USERNAME_TO_EXCLUDE_IF_ANY']
EMAIL_TO_ADMIN = os.environ['EMAIL_TO_ADMIN']
EMAIL_SEND_COMPLETION_REPORT = ast.literal_eval('True')
GROUP_LIST = os.environ['GROUP_LIST']

# Length of mask over the IAM Access Key
MASK_ACCESS_KEY_LENGTH = ast.literal_eval('16')

# First email warning
FIRST_WARNING_NUM_DAYS = os.environ['FIRST_WARNING_NUM_DAYS']
FIRST_WARNING_MESSAGE = 'IAM Access key is due to expire in 1 week (7 days)'

# Last email warning
LAST_WARNING_NUM_DAYS = os.environ['LAST_WARNING_NUM_DAYS']
LAST_WARNING_MESSAGE = 'IAM Access key is due to expire in 1 day (tomorrow)'

# Max AGE days of key after which it is considered EXPIRED (deactivated)
KEY_MAX_AGE_IN_DAYS = os.environ['KEY_MAX_AGE_IN_DAYS']
KEY_EXPIRED_MESSAGE = 'IAM Access key is now EXPIRED! Changing key to INACTIVE state'
KEY_YOUNG_MESSAGE = 'IAM Access key is still young'

# ==========================================================

# Character length of an IAM Access Key
ACCESS_KEY_LENGTH = 20
KEY_STATE_ACTIVE = "Active"
KEY_STATE_INACTIVE = "Inactive"

# ==========================================================

# check to see if the MASK_ACCESS_KEY_LENGTH has been misconfigured
if MASK_ACCESS_KEY_LENGTH > ACCESS_KEY_LENGTH:
    MASK_ACCESS_KEY_LENGTH = 16


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
      iam_keys(sessions, region)


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

def mask_access_key(access_key):
  return access_key[-(ACCESS_KEY_LENGTH - MASK_ACCESS_KEY_LENGTH):].rjust(len(access_key), "*")

def key_age(key_created_date):
  tz_info = key_created_date.tzinfo
  age = datetime.now(tz_info) - key_created_date
  print('key age %s' % age)

  key_age_str = str(age)
  if 'days' not in key_age_str:
    return 0

  days = int(key_age_str.split(',')[0].split(' ')[0])
  return days

def send_deactivate_email(email_to, username, age, access_key_id):
  sns = boto3.client('sns')
  data = 'The Access Key [%s] belonging to User [%s] has been automatically ' \
         'deactivated due to it being %s days old' % (access_key_id, username, age)
  response = sns.publish(
    TopicArn=email_to,
    Message='%s ' % data,
  )


def send_completion_email(email_to, finished, deactivated_report):
  sns = boto3.client('sns')
  data = 'AWS IAM Access Key Rotation Lambda Function (cron job) finished successfully at %s \n \n ' \
         'Deactivation Report:\n%s' % (finished, json.dumps(deactivated_report, indent=4, sort_keys=True))
  email = False
  for dr in range(len(deactivated_report['users'])):
    for keys in range(len(deactivated_report['users'][dr]['keys'])):
      if deactivated_report['users'][dr]['keys'][keys]['age'] >= int(LAST_WARNING_NUM_DAYS):
        email = True
  if email:
    response = sns.publish(
      TopicArn=email_to,
      Message='%s' % data,
    )


# Custom code goes here, this runs in the accounts and regions passed in
def iam_keys(s, region):
  if s == 'current':
    client = boto3.client('iam')
  else:
    client = s.client('iam')

  print('*****************************')
  print('RotateAccessKey (%s): starting...' % BUILD_VERSION)
  print('*****************************')

  users = {}
  data = client.list_users()
  print(data)

  userindex = 0

  for user in data['Users']:
    userid = user['UserId']
    username = user['UserName']
    users[userid] = username

  users_report1 = []
  users_report2 = []

  for user in users:
    userindex += 1
    user_keys = []

    print('---------------------')
    print("userindex %s" % userindex)
    print('user %s' % user)
    username = users[user]
    print('username %s' % username)

    # test is a user belongs to a specific list of groups. If they do, do not invalidate the access key
    print("Test if the user belongs to the exclusion group")
    user_groups = client.list_groups_for_user(UserName=username)
    skip = False
    for groupName in user_groups['Groups']:
      if groupName['GroupName'] == GROUP_LIST:
        print('Detected that user belongs to %s' % GROUP_LIST)
        skip = True
        continue

    # check to see if the current user is a part of the exclusion group
    if skip:
        print('detected special group member %s, skipping account...' % username)
        continue

    # check to see if the current user is a special service account
    if username == SERVICE_ACCOUNT_NAME:
        print('detected special service account %s, skipping account...' % username)
        continue

    access_keys = client.list_access_keys(UserName=username)['AccessKeyMetadata']
    for access_key in access_keys:
      print(access_key)
      access_key_id = access_key['AccessKeyId']
      masked_access_key_id = mask_access_key(access_key_id)
      print('AccessKeyId %s' % masked_access_key_id)

      existing_key_status = access_key['Status']
      print(existing_key_status)

      key_created_date = access_key['CreateDate']
      print('key_created_date %s' % key_created_date)

      age = key_age(key_created_date)
      print('age %s' % age)

      # we only need to examine the currently Active and about to expire keys
      if existing_key_status == "Inactive":
        key_state = 'key is already in an INACTIVE state'
        key_info = {'accesskeyid': masked_access_key_id, 'age': age, 'state': key_state, 'changed': False}
        user_keys.append(key_info)
        continue

      key_state = ''
      key_state_changed = False
      if age < int(FIRST_WARNING_NUM_DAYS):
        key_state = KEY_YOUNG_MESSAGE
      elif age == int(FIRST_WARNING_NUM_DAYS):
        key_state = FIRST_WARNING_MESSAGE
      elif age == LAST_WARNING_NUM_DAYS:
        key_state = LAST_WARNING_MESSAGE
      elif age >= int(KEY_MAX_AGE_IN_DAYS):
        key_state = KEY_EXPIRED_MESSAGE
        client.update_access_key(UserName=username, AccessKeyId=access_key_id, Status=KEY_STATE_INACTIVE)
        send_deactivate_email(EMAIL_TO_ADMIN, username, age, masked_access_key_id)
        key_state_changed = True

      print('key_state %s' % key_state)

      key_info = {'accesskeyid': masked_access_key_id, 'age': age, 'state': key_state,
                  'changed': key_state_changed}
      user_keys.append(key_info)

    user_info_with_username = {'userid': userindex, 'username': username, 'keys': user_keys}
    user_info_without_username = {'userid': userindex, 'keys': user_keys}

    users_report1.append(user_info_with_username)
    users_report2.append(user_info_without_username)

  finished = str(datetime.now())
  deactivated_report1 = {'reportdate': finished, 'users': users_report1}
  print('deactivated_report1 %s ' % deactivated_report1)

  if EMAIL_SEND_COMPLETION_REPORT:
    deactivated_report2 = {'reportdate': finished, 'users': users_report2}
    send_completion_email(EMAIL_TO_ADMIN, finished, deactivated_report2)

  print('*****************************')
  print('Completed (%s): %s' % (BUILD_VERSION, finished))
  print('*****************************')
  return deactivated_report1


# Only required for testing locally
# if __name__ == "__main__":
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

  # handler({
  #   "id": "cdc73f9d-aea9-11e3-9d5a-835b769c0d9c",
  #   "detail-type": "Scheduled Event",
  #   "source": "aws.events",
  #   "account": "123456789012",
  #   "time": "1970-01-01T00:00:00Z",
  #   "region": "ap-southeast-2",
  #   "resources": [
  #     "arn:aws:events:ap-southeast-2:123456789012:rule/ExampleRule"
  #   ],
  #   "detail": {}
  # }, '1')
