import boto3
import os
import json
from botocore.exceptions import ClientError

def assume_role(account_id, session_name, sts, role):
  resp = sts.assume_role(RoleArn='arn:aws:iam::' + account_id + ':role/' + role,
                        RoleSessionName=session_name)
  return boto3.Session(aws_access_key_id=resp['Credentials']['AccessKeyId'],
                      aws_secret_access_key=resp['Credentials']['SecretAccessKey'],
                      aws_session_token=resp['Credentials']['SessionToken'])

def core_functions(account, role):
  session = assume_role(account, 'sess', boto3.client('sts'), role)
  return session

def handler(e, c):
  print(json.dumps(e))
  snapshot_size_manager(e)

def cpt(tl):
  vals = []
  fields = tl.split(',')
  vals.append({
      "Key": fields[0],
      "Value": fields[1],
    })
  return vals

def snapshot_size_manager(e):
  tags_to_copy_keys = 'Used'
  queue_url = os.environ['ENV_SQSQUEUE']
  role = os.environ["ROLE"]
  blockSize = 524288
  sqs = boto3.client('sqs')

  # message hasn't failed yet
  failed_message = False

  try:
      message = e['Records'][0]['body']
  except KeyError:
      print('No messages on the queue!')

  try:
    receipt_handle = e['Records'][0]['receiptHandle']
    vol = json.loads(e['Records'][0]['body'])['volume']
    account = json.loads(e['Records'][0]['body'])['account']
    region = json.loads(e['Records'][0]['body'])['region']

    s = assume_role(account, 'sess', boto3.client('sts'), role)
    sess = s.resource('ec2', region_name=region)
    ebs = s.client('ebs', region_name=region)
    rm = s.client('ec2', region_name=region)
    rg = s.client('resourcegroupstaggingapi', region_name=region)

    snapshots = sess.snapshots.filter(Filters=[{'Name': 'volume-id', 'Values': [vol]}], OwnerIds=['self'])

    jq = []
    for sl in snapshots:
      jq.append((sl.volume_id, sl.id, sl.start_time))
    snaps = sorted(jq, key=lambda x: (x[0], x[2]))

    first = True
    s = ''
    print('processing:', account, region, vol)
    for i in range(len(snaps)):
      s = snaps[i][1]
      if first:
        s_prev = s
        rem = rm.delete_tags(Resources=[s], Tags=[{'Key': tags_to_copy_keys}])
        first = False
      if s != s_prev:
        changed = len(ebs.list_changed_blocks(FirstSnapshotId=s_prev, SecondSnapshotId=s)['ChangedBlocks'])
        print(s, "is a child to:" + s_prev, "," + str(round(changed * (blockSize / 1024 / 1024 / 1024), 2)) + 'GB')
        paginator = rg.get_paginator('get_resources')
        resource_iterator = paginator.paginate(
          ResourceARNList=['arn:aws:ec2:' + region + ':' + account + ':snapshot/' + s])
        for page in resource_iterator:
          for rr in range(len(page['ResourceTagMappingList'])):
            for tags in range(len(page['ResourceTagMappingList'][rr])):
              if 'Used' in str(page['ResourceTagMappingList'][rr]['Tags'][tags]):
                print('Compare Tag with Estimated:', page['ResourceTagMappingList'][rr]['Tags'][tags]['Value'],' --> ', str(round(changed * (blockSize / 1024 / 1024 / 1024), 2)) + 'GB')
                if page['ResourceTagMappingList'][rr]['Tags'][tags]['Value'] != str(round(changed * (blockSize / 1024 / 1024 / 1024), 2)) + 'GB':
                  st = sess.Snapshot(id=s)
                  wo = st.create_tags(Tags=cpt(tags_to_copy_keys + ',' + str(round(changed * (blockSize / 1024 / 1024 / 1024), 2)) + 'GB'))
      s_prev = s

  except ClientError as e:
    print(f'Error: on processing message, {e}')
    print('error json:', json.dumps(e))
    failed_message = True
  except Exception as e:
    print(f'Error: on processing message, {e}')
    failed_message = True

  # message must have passed, deleting
  if failed_message is False:
      sqs.delete_message(
          QueueUrl=queue_url,
          ReceiptHandle=receipt_handle,
      )

if __name__ == "__main__":
  # sqs = boto3.client('sqs')
  # response = sqs.receive_message(
  #   QueueUrl='https://sqs.ap-southeast-2.amazonaws.com/712277504610/bedrock-CentralFramework-SnapshotSizeManager-MyQueue-O40LJUVTF0WX',
  #   AttributeNames=['All'],
  #   MaxNumberOfMessages=1
  # )

  response={
    "Records": [
        {
            "messageId": "1056a4e1-29cf-451f-8e96-b9c8f94a8c7b",
            "receiptHandle": "AQEBMu7mziu3rNwfDcLc0lyX0LlT4wrsMMcHqQp44raEJMgL2dl5srpf14MD915kq7XDk9TbwYxA47cLmFFk2jp8iLlXld619DNl3bPKOyeP7QA0PJ0gjI4ZJocXrUM1/b2oTNydkJDUXbRmc1CA5ViUjcQpNVDTMJNQ+op49vkFwRz4Nia3DBIsbfsx9d9NNzbyKjCRIaimeAm7S0gap4mUUPqTXSqA0Dt2DNreSkHaHFGBcHw3FkQrF5FZZ5Z4cF5YGgBxeRwC6U4i2j+S8VDZ1+sGeI2rQZOY9HvavNK5Hldtse840S3dfyQa1C4bal1kd8kgBIhlmYtoTN+RqXFLlT9OLM2YLuetKMYEYYmhPgtpMYq9qgs+jr8uLS/QO8LG2EOXdFk+eiv0BjdWlCCxmdo28o2l1hYWJc+llaX6iSbB39WY75D0vvSr0+lgLhaBcNs4sTOqGIk4BY0TVkhyEA==",
            "body": "{\"account\": \"795775130216\",\"region\": \"ap-southeast-2\",\"volume\": \"vol-03bcd28bcaf3ed8f1\"}",
            "attributes": {
                "ApproximateReceiveCount": "1",
                "SentTimestamp": "1624603143757",
                "SenderId": "AROAZV6UKJZL2LUNEGR7U:bedrock-CentralFramework-SnapshotSizeManager",
                "ApproximateFirstReceiveTimestamp": "1624603148650"
            },
            "messageAttributes": {},
            "md5OfBody": "95f772fb4fcf8d6622a8a2b5cfebb127",
            "eventSource": "aws:sqs",
            "eventSourceARN": "arn:aws:sqs:ap-southeast-2:665628331607:shared-20-lambda-ec2-snapshot-size-manager-MyQueue-1N9702JYZ9K9D",
            "awsRegion": "ap-southeast-2"
        }
    ]
}
  handler(response,'1')
