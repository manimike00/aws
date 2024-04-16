resource "aws_wafv2_web_acl_logging_configuration" "logging" {
  log_destination_configs = var.log_destination_configs
  resource_arn            = var.resource_arn
}

