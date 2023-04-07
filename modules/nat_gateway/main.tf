resource "aws_nat_gateway" "natgw" {
  allocation_id = var.allocation_id
  subnet_id     = var.subnet_id
  tags = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
  }
}