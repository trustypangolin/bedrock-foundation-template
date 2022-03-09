# Security Requirements Traceability Matrix

Asset Management
---

| <div style="width:350px">Standard Control Approach</div>                                                    | Reference | PCI V3.2.1 | APRA CPG 234 | CSA CCM V3.0.1 | ISO 27001:2013 | ISO 27017:2015 | GDPR 2016/679 | CIS v7        | CIS AWS 1.2 | ACSC Protect |
| ----------------------------------------------------------------------------------------------------------- | --------- | ---------- | ------------ | -------------- | -------------- | -------------- | ------------- | ------------- | ----------- | ------------ | 
| Development of tagging strategy to assist in asset inventory, ownership and classification of information   |           |            |      45      | DSI-04         | 8.1.1, 8.1.2   | 8.1.1, 8.1.2   |               |               |             |              |
| Secure disposal of media as per AWS Controls                                                                |           | 3.1        |      55      |                | 8.3.2          | 8.3.2          |               |               |             |              |



Network Security
---

| <div style="width:350px">Standard Control Approach</div>                                                              | Reference | PCI V3.2.1                 | APRA CPG 234       | CSA CCM V3.0.1 | ISO 27001:2013 | ISO 27017:2015 | GDPR 2016/679 | CIS v7                                | CIS AWS 1.2        | ACSC Protect |
| --------------------------------------------------------------------------------------------------------------------- | --------- | -------------------------- | ------------------ | -------------- | -------------- | -------------- | ------------- | ------------------------------------- | ------------------ | ------------ | 
| VPC security groups used to logically separate workloads and restrict traffic to authorised services and/or personnel |           |                            | 48, 49, 52, 53, 58 | IVS-06         | 13.1.1, 13.1.3 | 13.1.1, 13.1.3 |               | 2.10, 9.4, 9.5, 12.4 14.1, 14.2, 14.3 | 4.3                |              |
| Security group rules and route tables are least privilege, with reasons documented for each rule                      |           | 1.1, 1.1.4, 1.2            | 48, 49, 52, 53, 58 | IVS-06         |                |                |               | 11.1, 11.2                            | 4.1, 4.2, 4.3, 4.4 |              |
| Workload types are segregated at the network layer via multi-tier VPCs                                                |           | 1.3.1, 1.3.2, 1.3.6, 1.3.7 | 48, 49, 52, 53, 58 | IVS-06         | 13.1.3         | 13.1.3         |               | 14.1                                  |                    |              |


Access Control
---

| <div style="width:350px">Standard Control Approach</div>                                                              | Reference | PCI V3.2.1 | APRA CPG 234 | CSA CCM V3.0.1 | ISO 27001:2013 | ISO 27017:2015 | GDPR 2016/679 | CIS v7        | CIS AWS 1.2 | ACSC Protect |
| --------------------------------------------------------------------------------------------------------------------- | --------- | ---------- | ------------ | -------------- | -------------- | -------------- | ------------- | ------------- | ----------- | ------------ | 
| AWS IAM password policy as per CIS AWS Benchmark                                                                      |           |            |              |                |                |                |               |               |             |              |
| Virtual Multi-factor authentication (MFA) configured and enforced for all IAM users                                   |           |            |              |                |                |                |               |               |             |              |
| Hardware Multi-factor authentication (MFA) configured for all root AWS accounts                                       |           |            |              |                |                |                |               |               |             |              |
| Alerts configured to detect breaches or potential breaches to AWS accounts                                            |           |            |              |                |                |                |               |               |             |              |
| Federated access to AWS (retain customers central point of authentication)                                            |           |            |              |                |                |                |               |               |             |              |
| Avoid usage of default administrator (root) accounts                                                                  |           |            |              |                |                |                |               |               |             |              |
| IAM policies attached to groups, and not individual IAM users                                                         |           |            |              |                |                |                |               |               |             |              |
| Configuration of IAM groups, policies and roles aligned to job functions, applying the principle of least privilege   |           |            |              |                |                |                |               |               |             |              |


Physical and Environmental Security
---

| <div style="width:350px">Standard Control Approach</div> | Reference | PCI V3.2.1 | APRA CPG 234 | CSA CCM V3.0.1 | ISO 27001:2013 | ISO 27017:2015 | GDPR 2016/679 | CIS v7        | CIS AWS 1.2 | ACSC Protect |
| -------------------------------------------------------- | --------- | ---------- | ------------ | -------------- | -------------- | -------------- | ------------- | ------------- | ----------- | ------------ |
|                                                          |           |            |              |                |                |                |               |               |             |              |


Documentation
---

| <div style="width:350px">Standard Control Approach</div> | Reference | PCI V3.2.1 | APRA CPG 234 | CSA CCM V3.0.1 | ISO 27001:2013 | ISO 27017:2015 | GDPR 2016/679 | CIS v7        | CIS AWS 1.2 | ACSC Protect |
| -------------------------------------------------------- | --------- | ---------- | ------------ | -------------- | -------------- | -------------- | ------------- | ------------- | ----------- | ------------ |
|                                                          |           |            |              |                |                |                |               |               |             |              |


Auditing
---

| <div style="width:350px">Standard Control Approach</div> | Reference | PCI V3.2.1 | APRA CPG 234 | CSA CCM V3.0.1 | ISO 27001:2013 | ISO 27017:2015 | GDPR 2016/679 | CIS v7        | CIS AWS 1.2 | ACSC Protect |
| -------------------------------------------------------- | --------- | ---------- | ------------ | -------------- | -------------- | -------------- | ------------- | ------------- | ----------- | ------------ |
|                                                          |           |            |              |                |                |                |               |               |             |              |


Operations Security
---

| <div style="width:350px">Standard Control Approach</div> | Reference | PCI V3.2.1 | APRA CPG 234 | CSA CCM V3.0.1 | ISO 27001:2013 | ISO 27017:2015 | GDPR 2016/679 | CIS v7        | CIS AWS 1.2 | ACSC Protect |
| -------------------------------------------------------- | --------- | ---------- | ------------ | -------------- | -------------- | -------------- | ------------- | ------------- | ----------- | ------------ |
|                                                          |           |            |              |                |                |                |               |               |             |              |


Monitoring and Maintenance
---

| <div style="width:350px">Standard Control Approach</div> | Reference | PCI V3.2.1 | APRA CPG 234 | CSA CCM V3.0.1 | ISO 27001:2013 | ISO 27017:2015 | GDPR 2016/679 | CIS v7        | CIS AWS 1.2 | ACSC Protect |
| -------------------------------------------------------- | --------- | ---------- | ------------ | -------------- | -------------- | -------------- | ------------- | ------------- | ----------- | ------------ |
|                                                          |           |            |              |                |                |                |               |               |             |              |

