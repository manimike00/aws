resource "aws_wafv2_web_acl" "this" {
  name  = var.name
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSRateBasedRuleDomesticDOS"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["JP"]
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSRateBasedRuleDomesticDOS"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSRateBasedRuleGlobalDOS"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 500
        aggregate_key_type = "IP"

        scope_down_statement {
          not_statement {
            statement {
              geo_match_statement {
                country_codes = ["JP"]
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSRateBasedRuleGlobalDOS"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSIPBlackList"
    priority = 3

    action {
      block {}
    }

    statement {
      or_statement {
        statement {
          ip_set_reference_statement {
            arn = var.alb_ipsets_v4
          }
        }
        statement {
          ip_set_reference_statement {
            arn = var.alb_ipsets_v6
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSIPBlackList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 10

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }


  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 30

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationListMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 40

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpListMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 50

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 60

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesUnixRuleSet"
    priority = 70

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesUnixRuleSetMetric"
      sampled_requests_enabled   = true
    }
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

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.metric_name
    sampled_requests_enabled   = true
  }
}

#resource "aws_wafv2_web_acl_logging_configuration" "api_server_waf_log" {
#  log_destination_configs = [var.log_destination_configs]
#  resource_arn            = aws_wafv2_web_acl.this.arn
#}

### IPv4 Set
##resource "aws_wafv2_ip_set" "wafv2_ip_set" {
##  count              = var.addresses != true ? 1 : 0
##  ip_address_version = "IPV4"
##  name               = var.name
##  scope              = var.scope
##  addresses          = var.addresses
##}
#
## Define the AWS WAF Web ACL
#resource "aws_wafv2_web_acl" "wafv2_web_acl" {
#  name        = var.name
#  description = "${var.name} WAF rules."
#  scope       = var.scope
#
#  default_action {
#    allow {}
#  }
#
#  dynamic "rule" {
#    for_each = var.rules
#    content {
#      name     = rule.value["name"]
#      priority = rule.value["priority"]
#
#      override_action {
#        none {}
#      }
#
#      visibility_config {
#        cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
#        metric_name                = "${lower(rule.value["name"])}_metrics"
#        sampled_requests_enabled   = false
#      }
#
#      statement {
##        # Managed AWS Rules
##        managed_rule_group_statement {
##          name        = rule.value.managed_rule_name != null ? rule.value.managed_rule_name : null
##          vendor_name = rule.value.managed_rule_name != null ? rule.value.vendor_name : null
##        }
#        # Geo Location
#        geo_match_statement {
#          country_codes = rule.value.country_codes != null ? rule.value.country_codes : null
#        }
##        # IP Restriction
##        ip_set_reference_statement {
##          arn = rule.value.addresses != null ? aws_wafv2_ip_set.wafv2_ip_set.0.arn : null
##        }
##        # rate limiting
##        rate_based_statement {
##          limit = var.rate_limit
##        }
#      }
#
#    }
#  }
#
##  tags = var.tags
#
#  visibility_config {
#    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
#    metric_name                = "${var.name}_rule_metrics"
#    sampled_requests_enabled   = false
#  }
#
#}
