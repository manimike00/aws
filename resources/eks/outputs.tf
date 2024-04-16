## kubernetes api-server security group
#output "kube_api_server_sg" {
#  value = module.eks.kube_api_server_sg
#}
#
## kubernetes kube_api_server
#output "kube_api_server" {
#  value = module.eks.kube_api_server
#}
#
#output "openid_url" {
#  value = trim(module.eks.openid_url, "https://")
#}

#output "thumbprint" {
#  value = module.eks.thumbprint
#}

output "vpc" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "subnets" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}