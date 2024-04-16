resource "aws_iam_policy" "policy" {
  name        = var.name
  description = var.description
  policy      = var.policy
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