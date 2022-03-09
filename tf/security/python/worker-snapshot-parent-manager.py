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

def handler(e, c):
  print(json.dumps(e))
  snapshot_parent_manager(e)

def snapshot_parent_manager(e):
  queue_url = os.environ['ENV_SQSQUEUE']
  role = os.environ["ROLE"]
  sqs = boto3.client('sqs')

  # message hasn't failed yet
  failed_message = False

  try:
    message = e['Records'][0]['body']
  except KeyError:
    print('No messages on the queue!')

  try:
    receipt_handle = e['Records'][0]['receiptHandle']
    snapshot = json.loads(e['Records'][0]['body'])['snapshot']
    account = json.loads(e['Records'][0]['body'])['account']
    region = json.loads(e['Records'][0]['body'])['region']

    s = assume_role(account, 'sess', boto3.client('sts'), role)
    ec2 = s.resource('ec2', region_name=region)
    rm = s.client('ec2', region_name=region)
    rg = s.client('resourcegroupstaggingapi', region_name=region)

    volumes = ec2.volumes.all()
    snapshots = ec2.snapshots.filter(OwnerIds=['self'], Filters=[{'Name': 'snapshot-id', 'Values': [snapshot]}])
    ami = ec2.images.filter(Owners=['self'])

    totalvols = []
    totalsnaps = []
    totalamis = []
    existingorphans = []
    existingvols = []
    existingamis = []

    for a in ami:
      for b in range(len(a.block_device_mappings)):
        try:
          snap = a.block_device_mappings[b]['Ebs']['SnapshotId']
          totalamis.append((account, region, snap))
        except KeyError:
          pass
        except ValueError:
          pass
    totalamis = sorted(totalamis, key=lambda x: (x[0], x[1], x[2]))

    for v in volumes:
      if len(v.snapshot_id) > 0:
        totalvols.append((account, region, v.snapshot_id))
    totalvols = sorted(set(sorted(totalvols, key=lambda x: (x[0], x[1], x[2]))))

    for sl in snapshots:
      totalsnaps.append((account, region, sl.id))
      for v in volumes:
        if sl.volume_id == v.volume_id:
          totalvols.append((account, region, sl.id))
    totalsnaps = sorted(totalsnaps, key=lambda x: (x[0], x[1], x[2]))

    amisnaps    = sorted(set(totalsnaps).intersection(set(totalamis)))
    volsnaps    = sorted(set(totalsnaps).intersection(set(totalvols)))
    orphansnaps = sorted(set(totalsnaps)-set(amisnaps)-set(volsnaps))

    paginator = rg.get_paginator('get_resources')
    resource_iterator = paginator.paginate(
      ResourceARNList=['arn:aws:ec2:'+region+':'+account+':snapshot/'+snapshot])
    for page in resource_iterator:
      for rr in range(len(page['ResourceTagMappingList'])):
        for tags in range(len(page['ResourceTagMappingList'][rr])):
          if 'ORPHAN' in str(page['ResourceTagMappingList'][rr]['Tags'][tags]):
            existingorphans.append((account, region, page['ResourceTagMappingList'][rr]['ResourceARN'].split('/')[1]))
          if 'VOL' in str(page['ResourceTagMappingList'][rr]['Tags'][tags]):
            existingvols.append((account, region, page['ResourceTagMappingList'][rr]['ResourceARN'].split('/')[1]))
          if 'AMI' in str(page['ResourceTagMappingList'][rr]['Tags'][tags]):
            existingamis.append((account, region, page['ResourceTagMappingList'][rr]['ResourceARN'].split('/')[1]))

    existingamis    = sorted(set(sorted(existingamis, key=lambda x: (x[0], x[1], x[2]))))
    existingorphans = sorted(set(sorted(existingorphans, key=lambda x: (x[0], x[1], x[2]))))
    existingvols    = sorted(set(sorted(existingvols, key=lambda x: (x[0], x[1], x[2]))))

    tagamis    = sorted(set(amisnaps)-set(existingamis))
    tagvolumes = sorted(set(volsnaps)-set(existingvols))
    tagorphans = sorted(set(orphansnaps)-set(existingorphans))

    rmamistag = sorted(set(existingamis).difference(amisnaps))
    rmvoltag  = sorted(set(existingvols).difference(volsnaps))
    rmorptag  = sorted(set(existingorphans).difference(orphansnaps))

  # Delete tags that need updating
    if len(rmamistag) > 0:
      for d in range(len(rmamistag)):
        try:
          tagme = rm.delete_tags(Resources=[rmamistag[d][2]], Tags=[{'Key': 'Parent'}])
          print('deleting tags:', rmamistag[d][2])
        except:
          continue

    if len(rmorptag) > 0:
      for d in range(len(rmorptag)):
        try:
          tagme = rm.delete_tags(Resources=[rmorptag[d][2]], Tags=[{'Key': 'Parent'}])
          print('deleting tags:', rmorptag[d][2])
        except:
          continue

    if len(rmvoltag) > 0:
      for d in range(len(rmvoltag)):
        try:
          tagme = rm.delete_tags(Resources=[rmvoltag[d][2]], Tags=[{'Key': 'Parent'}])
          print('deleting tags:', rmvoltag[d][2])
        except:
          continue

  # now add the tags that are missing
    if len(tagamis) > 0:
      for d in range(len(tagamis)):
        tag = ec2.Snapshot(id=tagamis[d][2])
        try:
          tagme = tag.create_tags(Tags=[{'Key': 'Parent', 'Value': 'AMI'}])
          print('Tagging snapshots with an existing AMI:', tagamis[d][2])
        except:
          continue

    if len(tagorphans) > 0:
      for d in range(len(tagorphans)):
        tag = ec2.Snapshot(id=tagorphans[d][2])
        try:
          tagme = tag.create_tags(Tags=[{'Key': 'Parent', 'Value': 'ORPHAN'}])
          print('Tagging snapshots with no owner as Orphan:', tagorphans[d][2])
        except:
          continue

    if len(tagvolumes) > 0:
      for d in range(len(tagvolumes)):
        tag = ec2.Snapshot(id=tagvolumes[d][2])
        try:
          tagme = tag.create_tags(Tags=[{'Key': 'Parent', 'Value': 'VOL'}])
          print('Tagging snapshots with an existing Volume:', tagvolumes[d][2])
        except:
          continue

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
  #   QueueUrl='https://sqs.ap-southeast-2.amazonaws.com/712277504610/bedrock-CentralFramework-SnapshotParentManager-MyQueue-F728B5NWV79W',
  #   AttributeNames=['All'],
  #   MaxNumberOfMessages=1
  # )

  response={
    "Records": [
        {
            "messageId": "4d6bb508-8a98-438b-b8f8-2372b5ac3602",
            "receiptHandle": "AQEBF72K53TxxBQ+w0reXBYRy81Gc2JRLNX/5TdVVuWGZGoR0nu10opiAXWaYjEt5dhwiwiX87OX9fec+TsjN83GQitva9wwyY6gHlfODNKBcmlAXAXjYptco9C93gThqcVsNerqKotMPK6H/NvTT+IkXjux5m8dvTK4S0YInv3eb8pVAVO5Nddb6vDrPJFIdPyrRssQGA73J5zYg0TnbjwdGDOhAgUxZOtMjMv/SdVXrTbb7cANwhUS/+LdWPpl9k3jV/M5wP2ExfKYACL6e/WQIZ0seqElynxZVSVvmqRDW5owdn2v4qyxvNsmUsGpVP0thFIz5CKiYkWTKwdP0ymqbOiucN36jJ2JaIxw6Xv5MAEoO9+KoM6Y6UiULTtf9WTWCuoCUFYML3tbVBeL6MjYg/fewU3q69E8/ujRtLthMIS8SSylUI1Sr1QmtTX7PoTlHOuGr38hdAhabBqlh+31VljlOO7ZvlQOdxgLdPkjMJU=",
            "body": "{\"account\": \"795775130216\", \"region\": \"ap-southeast-2\", \"snapshot\": \"snap-0759e58516a94dcb8\"}",
            "attributes": {
                "ApproximateReceiveCount": "1",
                "SentTimestamp": "1624935610347",
                "SenderId": "AROA2LVYMGJRNEBL2SRCJ:botocore-session-1624935531",
                "ApproximateFirstReceiveTimestamp": "1624935610394"
            },
            "messageAttributes": {},
            "md5OfBody": "3e8e3e028b3548c505c6cfab4ac1dfef",
            "eventSource": "aws:sqs",
            "eventSourceARN": "arn:aws:sqs:ap-southeast-2:712277504610:bedrock-CentralFramework-SnapshotParentManager-MyQueue-F728B5NWV79W",
            "awsRegion": "ap-southeast-2"
        }
    ]
  }
  handler(response, '1')
