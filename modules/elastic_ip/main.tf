resource "aws_eip" "eip" {
  vpc = var.vpc
  tags = {
    Name        = var.name
    Project     = var.project
    Location    = var.location
    Environment = var.env
  }
}