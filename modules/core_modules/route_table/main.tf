resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = var.cidr_block
    gateway_id     = var.type == "public" ? var.gateway_id : null
    nat_gateway_id = var.type == "public" ? null : var.nat_gateway_id
  }
  tags = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
  }
}