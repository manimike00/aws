variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

# virtual private cloud
variable "cidr_block" {}
variable "enable_dns_hostnames" {
  type = bool
}
variable "enable_dns_support" {
  type = bool
}