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

output "db_subnet_ids" {
  value = module.subnets[0].subnet_id
}
output "private_subnet_ids" {
  value = module.subnets[1].subnet_id
}
output "public_subnet_ids" {
  value = module.subnets[2].subnet_id
}
# internet gatwway
output "internet_gateway_arn" {
  value = module.internet_gateway.internet_gateway_arn
}
output "internet_gateway_id" {
  value = module.internet_gateway.internet_gateway_id
}

# elastic ip
output "elastic_ip" {
  value = module.elastic_ip.elastic_ip
}
output "elastic_private_ip" {
  value = module.elastic_ip.elastic_private_ip
}
output "elastic_id" {
  value = module.elastic_ip.elastic_id
}

# nat gateway
output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}

# route tables
output "public_route_table_id" {
  value = module.route_tables[0].route_table_id[0]
}
output "private_route_table_id" {
  value = module.route_tables[1].route_table_id[0]

}
output "db_route_table_id" {
  value = module.route_tables[2].route_table_id[0]
}