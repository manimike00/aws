resource "aws_eks_node_group" "eks_node_group" {

  node_group_name = var.name
  cluster_name    = var.cluster_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  update_config {
    max_unavailable = 1
  }

  capacity_type  = var.capacity_type
  disk_size      = var.disk_size
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
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
    ignore_changes = [scaling_config]
  }

}