output "s3_bucket" {
  value = aws_s3_bucket.s3.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3.arn
}

output "s3_bucket_id" {
  value = aws_s3_bucket.s3.id
}