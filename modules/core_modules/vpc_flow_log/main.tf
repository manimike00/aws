resource "aws_flow_log" "vpc_flow_log" {
  log_destination = var.log_destination
  log_destination_type = var.log_destination_type
  traffic_type = var.traffic_type
  vpc_id = var.vpc_id
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