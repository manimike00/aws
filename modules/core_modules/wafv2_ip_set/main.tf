resource "aws_wafv2_ip_set" "wafv2_ip_set" {
  name               = var.name
  scope              = var.scope
  ip_address_version = var.ip_address_version
#  provider           = var.scope == "CLOUDFRONT" ? aws.us-east-1 : null
  addresses          = var.addresses

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