# OUTPUT

output "waf_id" {
  value = aws_wafv2_web_acl.this.id
}
output "waf_arn" {
  value       = aws_wafv2_web_acl.this.arn
  description = "IP sets arn"
}

#output "s3_bucket_arn" {
#  value       = aws_s3_bucket.bucket.arn
#  description = "S3 bucket arn"
#}