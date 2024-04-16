module "s3" {
  source   = "../../core_modules/s3"
  bucket   = var.bucket
  name     = var.name
  env      = var.env
  location = var.location
  project  = var.project
}

module "wafv2_ip_set_ipv4" {
  source             = "../../core_modules/wafv2_ip_set"
  name               = "${var.name}-ipv4"
  env                = var.env
  location           = var.location
  project            = var.project
  addresses          = ["127.0.0.1/32"]
  ip_address_version = "IPV4"
  scope              = "REGIONAL"
}

module "wafv2_ip_set_ipv6" {
  source             = "../../core_modules/wafv2_ip_set"
  name               = "${var.name}-ipv6"
  env                = var.env
  location           = var.location
  project            = var.project
  addresses          = ["2001:0db8:0000:0000:0000:0000:0000:0001/128"]
  ip_address_version = "IPV6"
  scope              = "REGIONAL"
}

module "wafv2_alb" {
  source                  = "../../core_modules/wafv2"
  name                    = var.name
  env                     = var.env
  location                = var.location
  project                 = var.project
  metric_name             = var.metric_name
  alb_ipsets_v4           = module.wafv2_ip_set_ipv4.wafv2_ip_set_arn
  alb_ipsets_v6           = module.wafv2_ip_set_ipv6.wafv2_ip_set_arn
  log_destination_configs = module.s3.s3_bucket_arn
}

module "wafv2_logging" {
  depends_on              = [module.wafv2_alb]
  source                  = "../../core_modules/wafv2_web_acl_logging_configs"
  log_destination_configs = [module.s3.s3_bucket_arn]
  resource_arn            = module.wafv2_alb.waf_arn
}

#module "waf" {
#  source                     = "../../core_modules/waf"
#  name                       = "demo_waf"
#  scope                      = "REGIONAL"
#  cloudwatch_metrics_enabled = true
##  tags                       = merge(local.common_tags)
#  country_codes              = ["IN", "SG"]
#  rate_limit                 = 1000
#  rules                      = var.rules
#}