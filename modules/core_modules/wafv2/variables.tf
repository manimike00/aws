variable "name" {}
variable "location" {}
variable "env" {}
variable "project" {}

variable "metric_name" {
  type        = string
}

variable "alb_ipsets_v4" {
  type = string
}

variable "alb_ipsets_v6" {
  type = string
}

variable "log_destination_configs" {
  type = string
}

## Example variable for rules
#variable "rules" {
#  type = map(object({
#    name                       = string
#    priority                   = number
#    cloudwatch_metrics_enabled = bool
#    managed_rule_name          = string
#    vendor_name                = string
#  }))
#  default = {
#    rule1 = {
#      name                       = null
#      priority                   = null
#      cloudwatch_metrics_enabled = null
#      managed_rule_name          = null
#      vendor_name                = null
#      addresses                  = null
#      country_codes              = null
#    }
#  }
#}
#
#variable "name" {}
#variable "scope" {}
##variable "tags" {}
#
## Cloud Watch Metrics
#variable "cloudwatch_metrics_enabled" {
#  type = bool
#}
#
## Geo Location
#variable "country_codes" {
#  type = list(string)
#  default = null
#}
#
### IPv4 Set
##variable "addresses" {
##  type = list(string)
##  default = null
##}
#
## Rate Limit
#variable "rate_limit" {
#  type = number
#  default = null
#}