variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

variable "role_arn" {}
variable "k8s_version" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}

variable "endpoint_private_access" {
  type = bool
}

variable "endpoint_public_access" {
  type = bool
}