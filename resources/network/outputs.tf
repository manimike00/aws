# virtual private network
output "vpc_arn" {
  value = module.network.vpc_arn
}
output "vpc_id" {
  value = module.network.vpc_id
}
output "vpc_cidr_block" {
  value = module.network.vpc_cidr_block
}

# subnets
output "subnet_arns" {
  value = module.network.subnet_arn
}
output "subnet_id" {
  value = module.network.*.subnet_id
}
#output "subnet_cidr_block" {
#  value = module.network.*.
#}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}
output "db_subnet_ids" {
  value = module.network.db_subnet_ids
}
# internet gatwway
output "internet_gateway_arn" {
  value = module.network.internet_gateway_arn
}
output "internet_gateway_id" {
  value = module.network.internet_gateway_id
}

# elastic ip
output "elastic_ip" {
  value = module.network.elastic_ip
}
output "elastic_private_ip" {
  value = module.network.elastic_private_ip
}
output "elastic_id" {
  value = module.network.elastic_id
}

# nat gateway
output "nat_gateway_id" {
  value = module.network.nat_gateway_id
}

## route tables
#output "public_route_table_id" {
#  value = module.network[0].route_table_id[0]
#}
#output "private_route_table_id" {
#  value = module.network[1].route_table_id[0]
#
#}
#output "db_route_table_id" {
#  value = module.network[2].route_table_id[0]
#}