data "aws_availability_zones" "current" {}

resource "aws_subnet" "subnet" {
  count             = length(var.cidr_block)
  vpc_id            = var.vpc_id
#  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + var.subnet_range)
  cidr_block      = var.cidr_block[count.index]
  availability_zone = data.aws_availability_zones.current.names[count.index]
  tags = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
  }
  tags_all = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
  }
}