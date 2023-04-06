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