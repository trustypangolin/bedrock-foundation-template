output "vpc" {
  value = length(module.modules_vpc) > 0 ? module.modules_vpc.vpc : null
}
