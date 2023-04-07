# virtual private network (VPC)
module "vpc" {
  source               = "../modules/virtual_private_cloud"
  name                 = "${var.env}-${var.name}-${var.project}"
  env                  = var.env
  project              = var.project
  location             = var.location
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# private, public and db subnets
variable "types" {
  default = ["pub", "pri", "db"]
}
variable "subnet_range" {
  default = [10, 20, 30]
}
module "subnets" {
  source       = "../modules/subnets"
  count        = length(var.types)
  name         = "${var.env}-${var.name}-${var.project}-${var.types[count.index]}"
  env          = var.env
  project      = var.project
  location     = var.location
  vpc_id       = module.vpc.vpc_id
  cidr_block   = module.vpc.vpc_cidr_block
  subnet_range = var.subnet_range[count.index]
}

# internet gateway
module "internet_gateway" {
  source   = "../modules/internet_gateway"
  name     = "${var.env}-${var.name}-${var.project}"
  env      = var.env
  project  = var.project
  location = var.location
  vpc_id   = module.vpc.vpc_id
}

# elastic ip
module "elastic_ip" {
  source   = "../modules/elastic_ip"
  name     = "${var.env}-${var.name}-${var.project}"
  env      = var.env
  project  = var.project
  location = var.location
  vpc      = true
}

# nat gateway
module "nat_gateway" {
  source        = "../modules/nat_gateway"
  name          = "${var.env}-${var.name}-${var.project}"
  env           = var.env
  project       = var.project
  location      = var.location
  allocation_id = module.elastic_ip.elastic_id
  subnet_id     = module.subnets[0].subnet_id[0]
}

# route table setup
locals {
  route_tables = ["public", "private", "db"]
}

module "route_tables" {
  source         = "../modules/route_table"
  count          = length(local.route_tables)
  name           = "${var.env}-${var.name}-${var.project}-${local.route_tables[count.index]}"
  env            = var.env
  project        = var.project
  location       = var.location
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "0.0.0.0/0"
  type           = local.route_tables[count.index]
  gateway_id     = module.internet_gateway.internet_gateway_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}

module "rote_table_association" {
  source         = "../modules/route_table_association"
  count          = length(local.route_tables)
  route_table_id = module.route_tables[count.index].route_table_id[0]
  subnet_id      = module.subnets[count.index].subnet_id
}