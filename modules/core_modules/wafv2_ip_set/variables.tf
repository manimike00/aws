variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

# choose between cloudfront or alb
# allowed values "CLOUDFRONT or REGIONAL"
variable "scope" {}

# allowed values "IPV4 or IPV6"
variable "ip_address_version" {}

variable "addresses" {
  type = list(string)
}