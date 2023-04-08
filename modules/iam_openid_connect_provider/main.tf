resource "aws_iam_openid_connect_provider" "default" {
  url             = var.openid_url
  client_id_list  = var.client_id_list
  thumbprint_list = var.thumbprint_list
}
