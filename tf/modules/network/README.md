# Network Module
Provisions a VPC with:
1. A /16 CIDR range, with 9 or 12 (depending on number of AZs availible) /20 subnets (for public, private and secure).
2. Gateway endpoints for DynamoDB and S3.
3. S3 and Dynamo Gateway endpoints.
4. Routing tables and NACLs that implements Itoc's public, private and secure subnet methodology.
5. NAT Gateways + EIPs for the private subnets.


## Input Variables
Check out `variables.tf` for a comprehensive list of variables and defaults. At the time of writing here are the ideal required variables in an example instantiation:
```hcl
module "vpc" {
    source = "path/to/this/module"
    env = 
    prefix = "customer-prefix" # Arbitrary prefix for all resources
    region_prefix = "fr" # Appended to above for VPC's intended purpose
    network_prefix = "10.0" # First 2 octets of VPC
    instance_tenancy
    tags
    create_log_group_iam_role = true/false
    log_group_iam_role_arn = if create_log_group_iam_role = false, specify the iam role arn
    enable_monitoring_endpoint = true/false to deploy CW monitoring endpoint
    # -------- Number of NAT Gateways ------------------- 
    number_of_ngws
     # -------- VPC Peerings-------------------
     enable_vpc_peering = true/false
     vpc_peering_connections = list of objects with details of peer vpc
     vpc_peering_routes = list of objects with details of the routes
    # -------- Transit Gateway -------------------
    create_tgw                      = true/false
    amazon_side_asn                 = amazon_side_asn number - required if create_tgw = true
    auto_accept_shared_attachments  = enable/disable - required if create_tgw = true
    default_route_table_association = enable/disable - required if create_tgw = true
    default_route_table_propagation = enable/disable - required if create_tgw = true
    vpn_ecmp_support                = enable/disable - required if create_tgw = true
    dns_support                     = enable/disable - required if create_tgw = true
    allow_external_principals       = true/false - required if create_tgw = true
    account_ids                     = values(local.account_map) - - required if create_tgw = true
    tgw_owner                       = true/false
    external_vpc_attachments        = [] 
    propagate_attachments           = true/false
    custom_routes                   = [tgw_static_routes] if additional static route excluding the blackhole route
    tgw_route_table_blackhole_cidr  = var.tgw_blackhole_route
    custom_routes_to_tgw            = [] Route table routes for Secure, Public and Private Route Tables to direct internal traffic to TGW
    tgwpeer_account_id              = aws_account_id of tgw peer
    create_tgw_peering              = true/false
    tgw_peer_region                 = ""
    accept_tgw_peering              = false/true
    peer_transit_gateway_id         = ""
    peering_routes                  = [""] - Route for peerint TGW
}
```

## Outputs
Check `outputs.tf`

## Testing
See the test directory for a pre-made harness to see if the module plans/applies ok.