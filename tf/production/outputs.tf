output "vpc_id" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.vpc_id : null
}

output "vpc_cidr" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.vpc_cidr : null
}

output "subnet_ids" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.subnet_ids : null
}

output "public_subnet_ids" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.public_subnet_ids : null
}

output "private_subnet_ids" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.private_subnet_ids : null
}

output "private_subnet_cidrs" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.private_subnet_cidrs : null
}

output "isolated_subnet_ids" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.isolated_subnet_ids : null
}

output "isolated_subnet_cidrs" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.isolated_subnet_cidrs : null
}

output "public_rt_ids" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.public_rt_ids : null
}

output "private_rt_ids" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.private_rt_ids : null
}

output "isolated_rt_ids" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.isolated_rt_ids : null
}
