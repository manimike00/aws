variable "cluster_name" {}
variable "node_role_arn" {}
variable "subnet_ids" {
  type = list(string)
}

variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

variable "desired_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}

variable "capacity_type" {
  type    = string
  default = "SPOT"
  # values = SPOT and ON_DEMAND
}
variable "disk_size" {
  type = number
}
variable "instance_types" {
  type = list(string)
}