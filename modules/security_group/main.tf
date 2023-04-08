locals {
  inbound_ports  = [80, 443]
  outbound_ports = [443, 1433]
}


resource "aws_security_group" "allow_tls" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "ALL"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = local.outbound_ports
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "ALL"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

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
