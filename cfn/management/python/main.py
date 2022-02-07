import sys
import os
import json
import boto3
import cfnresponse

# CONDITIONS
if "ENVIRONMENT" not in os.environ: os.environ["ENVIRONMENT"]="local"

# HANDLER
def handler(e,c):
    if "ResponseURL" in e: cfnresponse.send(e, c, cfnresponse.SUCCESS, {}, '')
    print("REQUEST RECEIVED:\n" + json.dumps(e))
    if 'source' in e: print('Scheduled Event')
    if 'RequestType' in e:
      print('curl -H \'Content-Type: \'\'\' -X PUT -d \'{\n'
            '   "Status": "SUCCESS",\n'
            '   "PhysicalResourceId": "'  + e['LogicalResourceId']  + '",\n'
            '   "StackId": "'             + e['StackId']            + '",\n'
            '   "RequestId": "'           + e['RequestId']          + '",\n'
            '   "LogicalResourceId": "'   + e['LogicalResourceId']  + '"\n'
            '}\' \''                      + e['ResponseURL']        + '\''
            )
    response=core_functions(e,c)
    return response

# CORE
def core_functions(event,context):
    if "REPO" in os.environ:
      gr = os.environ['REPO']
    else: gr = ''
    org=boto3.client('organizations')
    accountList=org.list_accounts()['Accounts']

    for account in accountList:
        account_id=account["Id"]
        print(account_id)
        if account_id==os.environ['MASTER']:
            sts_cfn=boto3.resource('cloudformation',os.environ['REGION'])
        else:
            sess=assume_role(account_id,'stack-set-execution-role',boto3.client('sts'))
            sts_cfn=sess.resource('cloudformation',os.environ['REGION'])

        capabilities=['CAPABILITY_NAMED_IAM']
        tags=[{'Key':'Environment','Value':'All'}]

        templateBodyAdmin="""---
AWSTemplateFormatVersion: '2010-09-09'
Description: 'AWS IAM Role - Create StackSet Administration Role - Any Account/Region'
Resources:
  AdministrationRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: AWSCloudFormationStackSetAdministrationRole
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: cloudformation.amazonaws.com
            Action:
              - sts:AssumeRole
      Path: /
      Policies:
        - PolicyName: AssumeRole-AWSCloudFormationStackSetExecutionRole
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - sts:AssumeRole
                Resource:
                  - arn:aws:iam::*:role/AWSCloudFormationStackSetExecutionRole"""

        if account_id==os.environ['MASTER']:
            try:
                response=create_stack("Bedrock-management-stack-set-administration-role",templateBodyAdmin,capabilities,tags,sts_cfn)
                print(response)
            except:
                print("Admin Exec Stack failed to deploy - may already exist")

        templateBody="""---
AWSTemplateFormatVersion: '2010-09-09'
Description: 'AWS IAM Role - Create StackSet Execution Role - Any Account/Region'
Resources:
  ExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: AWSCloudFormationStackSetExecutionRole
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              AWS:
                - """ + os.environ['MASTER'] + """
            Action:
              - sts:AssumeRole
      Path: /
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AdministratorAccess"""

        try:
            response=create_stack("Bedrock-all-stack-set-execution-role",templateBody,capabilities,tags,sts_cfn)
            print(response)
        except:
            print("Exec Stack failed to deploy - may already exist")

        templateBody="""---
AWSTemplateFormatVersion: '2010-09-09'
Description: 'AWS IAM Role - Create OIDC Github - Any Account/Region'
Resources:
  ExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: Github-Admin
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              AWS:
                - Fn::Join:
                    - ':'
                    - - 'arn:aws:iam:'
                      - """+os.environ['MASTER']+"""
                      - 'role/Github-Bootstrap'
            Action:
              - sts:AssumeRole
      Path: /
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AdministratorAccess""".format(gr)

        if len(gr) > 0:
          try:
              response=create_stack("Bedrock-github-admin",templateBody,capabilities,tags,sts_cfn)
              print(response)
          except:
              print("Github Stack failed to deploy - may already exist, attempting an update stack instead")
              try:
                  response=update_stack("Bedrock-github-admin",templateBody,capabilities,tags,sts_cfn)
                  print(response)
              except:
                  print("Github Stack failed to deploy - Permissions?")

def assume_role(account_id,session_name,sts):
    resp=sts.assume_role(RoleArn='arn:aws:iam::'+account_id+':role/OrganizationAccountAccessRole',RoleSessionName=session_name)
    return boto3.Session(aws_access_key_id=resp['Credentials']['AccessKeyId'],aws_secret_access_key=resp['Credentials']['SecretAccessKey'],aws_session_token=resp['Credentials']['SessionToken'])

def create_stack(stackName,templateBody,capabilities,tags,cfn):
    if len(capabilities) > 0: return cfn.create_stack(StackName=stackName,TemplateBody=templateBody,Capabilities=capabilities,Tags=tags)
    else: return cfn.create_stack(StackName=stackName,TemplateBody=templateBody,Tags=tags)

def update_stack(stackName,templateBody,capabilities,tags,cfn):
    if len(capabilities) > 0: return cfn.update_stack(StackName=stackName,TemplateBody=templateBody,Capabilities=capabilities,Tags=tags)
    else: return cfn.update_stack(StackName=stackName,TemplateBody=templateBody,Tags=tags)

# LOCAL
if os.environ["ENVIRONMENT"]=="local":
    handler("","")