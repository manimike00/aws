# virtual private network
output "vpc_arn" {
  value = module.vpc.vpc_arn
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

# subnets
output "subnet_arn" {
  value = module.subnets.*.subnet_arn
}
output "subnet_id" {
  value = module.subnets.*.subnet_id
}
output "subnet_cidr_block" {
  value = module.subnets.*.subnet_cidr
}