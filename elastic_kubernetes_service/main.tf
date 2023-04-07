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

variable "types" {
  default = ["pub", "pri", "db"]
}

variable "subnet_range" {
  default = [10,20,30]
}

# private, public and db subnets
module "subnets" {
  source     = "../modules/subnets"
  count      = length(var.types)
  name       = "${var.env}-${var.name}-${var.project}-${var.types[count.index]}"
  env        = var.env
  project    = var.project
  location   = var.location
  vpc_id     = module.vpc.vpc_id
  cidr_block = module.vpc.vpc_cidr_block
  subnet_range = var.subnet_range[count.index]
}