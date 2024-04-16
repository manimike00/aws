output "kube_api_server" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_openid_url" {
  value = aws_eks_cluster.eks.identity.0.oidc.0.issuer
}