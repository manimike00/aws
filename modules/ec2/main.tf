resource "aws_iam_instance_profile" "profile" {
  name = var.name
  role = var.role
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


resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  security_groups             = var.security_groups
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.user_data
  monitoring                  = var.monitoring

  root_block_device {
    delete_on_termination = var.delete_on_termination
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    tags = {
      Name        = var.name
      Project     = var.project
      Location    = var.location
      Environment = var.env
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

  lifecycle {
    ignore_changes = [security_groups]
  }

}
