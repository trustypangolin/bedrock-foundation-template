# Terraform
## Org Project Folder
### Architectural Design
![Design](/terraform/org/images/Terraform-LZ-Org.png)

### Mandatory Variables
![Variables](/terraform/org/images/Terraform-LZ-Org-Variables.png)

**unique_prefix** is used for globally unique resources naming such as s3 **buckets**

**base_region** is the initial region where resources are managed from by default. Default is ap-southeast-2 if not specified. Example would be s3 bucket location for billing, TF state and so forth

**root_emails** are the root emails required for each AWS account created. These must be checked as valid before deploying. Google Workspace can natively utilise +aliasing to reduce email licensing costs eg: aws+root.accountname@domain.com would map to aws@domain.com. Office365 may need a powershell script to activate this feature

**acc_map** is used as a lookup mapping for 'functionality' of an account to the actual name of the account. All projects use local lookups of the Org terraform remote state to determine account IDs. Actual account IDs (ie ***123456789012***) are *not used* at all within the code to keep it *DRY*. The names specified will match what shows in the SSO landing page or AWS Organization

**grafana_id** is an *example* output that can be referenced across all projects. Rather than populate every project with this value, it can be specified in the Org state, and referenced elsewhere as a local. It doesn't have to be Grafana, it could be any API variable that needs to be referenced in all projects

**backup_regions** and **backup_crons** affects the AWS Backup Policy, and can be modified to suit. Default values for threee regions have been specified

