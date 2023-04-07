variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

variable "type" {}
variable "vpc_id" {}
variable "cidr_block" {}
variable "gateway_id" {
  default = null
}
variable "nat_gateway_id" {
  default = null
}
