module "wafv2" {
  source      = "../../modules/service_modules/wafv2"
  name        = ""
  env         = ""
  location    = ""
  project     = ""
  bucket      = ""
  metric_name = ""
}

#locals {
#  rules = {
#
##    rule1 = {
##      name                       = "AWSManagedRulesCommonRuleSet"
##      priority                   = 10
##      cloudwatch_metrics_enabled = true
##      managed_rule_name          = "AWSManagedRulesCommonRuleSet"
##      vendor_name                = "AWS"
##    }
#
##    rule2 = {
##      name                       = "AWSManagedRulesKnownBadInputsRuleSet"
##      priority                   = 20
##      cloudwatch_metrics_enabled = true
##      managed_rule_name          = "AWSManagedRulesKnownBadInputsRuleSet"
##      vendor_name                = "AWS"
##    }
#
#    rule3 = {
#      name                       = "GeoLocation"
#      managed_rule_name          = null
#      vendor_name                = null
#      priority                   = 30
#      cloudwatch_metrics_enabled = true
#      country_codes              = ["IN","SG"]
#    }
#
#  }
#}
#
#module "waf" {
#  source = "../../modules/service_modules/wafv2"
#  rules = local.rules
#}