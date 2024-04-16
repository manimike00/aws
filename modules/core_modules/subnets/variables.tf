# general variables
variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

# subnets variables
variable "vpc_id" {}
variable "cidr_block" {
  type = list(string)
}
#variable "subnet_range" {}
