## kubernetes api-server security group
#output "kube_api_server_sg" {
#  value = module.security_group.security_group_id
#}
#
## kubernetes kube_api_server
#output "kube_api_server" {
#  value = module.eks.kube_api_server
#}
#
#output "openid_url" {
#  value = trim(module.eks.cluster_openid_url, "https://")
#}
#
#output "thumbprint" {
#  value = data.tls_certificate.openid.certificates.0.sha1_fingerprint
#}