resource "aws_athena_database" "athena_database" {
  name = var.name
  bucket = var.bucket
}