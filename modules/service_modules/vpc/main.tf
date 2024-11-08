# virtual private network (VPC)
module "vpc" {
  source               = "../../core_modules/virtual_private_cloud"
  name                 = "${var.env}-${var.name}-${var.project}"
  env                  = var.env
  project              = var.project
  location             = var.location
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
}

## Subnets locals
locals {
  subnets = {
    pub = var.public_cidr,
    pri = var.private_cidr,
    db  = var.db_cidr
  }
}

module "subnets" {
  source     = "../../core_modules/subnets"
  count      = length(local.subnets)
  name       = "${var.env}-${var.name}-${var.project}-${keys(local.subnets)[count.index]}"
  env        = var.env
  project    = var.project
  location   = var.location
  vpc_id     = module.vpc.vpc_id
  cidr_block = local.subnets[keys(local.subnets)[count.index]]
}

# internet gateway
module "internet_gateway" {
  source   = "../../core_modules/internet_gateway"
  name     = "${var.env}-${var.name}-${var.project}"
  env      = var.env
  project  = var.project
  location = var.location
  vpc_id   = module.vpc.vpc_id
}

# elastic ip
module "elastic_ip" {
  source   = "../../core_modules/elastic_ip"
  name     = "${var.env}-${var.name}-${var.project}"
  env      = var.env
  project  = var.project
  location = var.location
}

# nat gateway
module "nat_gateway" {
  source        = "../../core_modules/nat_gateway"
  name          = "${var.env}-${var.name}-${var.project}"
  env           = var.env
  project       = var.project
  location      = var.location
  allocation_id = module.elastic_ip.elastic_id
  subnet_id     = module.subnets[0].subnet_id[0]
}

module "route_tables" {
  source         = "../../core_modules/route_table"
  count          = length(local.subnets)
  name           = "${var.env}-${var.name}-${var.project}-${keys(local.subnets)[count.index]}"
  env            = var.env
  project        = var.project
  location       = var.location
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "0.0.0.0/0"
  type           = keys(local.subnets)[count.index]
  gateway_id     = module.internet_gateway.internet_gateway_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}

module "rote_table_association" {
  source         = "../../core_modules/route_table_association"
  count          = length(local.subnets)
  route_table_id = module.route_tables[count.index].route_table_id[0]
  subnet_id      = module.subnets[count.index].subnet_id
}

module "vpc_flowlog_s3" {
  source   = "../../core_modules/s3"
  bucket   = "${var.env}${var.name}${var.project}vpcflowlogs"
  name     = "${var.env}-${var.name}-${var.project}"
  env      = var.env
  project  = var.project
  location = var.location
}

module "vpc_flowlog" {
  source               = "../../core_modules/vpc_flow_log"
  name                 = "${var.env}-${var.name}-${var.project}"
  env                  = var.env
  project              = var.project
  location             = var.location
  log_destination      = module.vpc_flowlog_s3.s3_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc.vpc_id
}

module "athena_database" {
  source = "../../core_modules/athena_database"
  name = "${var.env}${var.name}${var.project}"
  bucket = module.vpc_flowlog_s3.s3_bucket_id
}