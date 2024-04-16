# elastic kubernetes service role
module "eks_role" {
  source             = "../../core_modules/iam_role"
  name               = "${var.env}-${var.name}-${var.project}"
  env                = var.env
  project            = var.project
  location           = var.location
  description        = "kubernetes api-server role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

locals {
  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
}

module "eks_role_attachment" {
  source     = "../../core_modules/iam_role_policy_attachment"
  count      = length(local.policies)
  policy_arn = local.policies[count.index]
  role       = module.eks_role.iam_role_name
}

# node group role
module "node_group_role" {
  source             = "../../core_modules/iam_role"
  name               = "${var.env}-${var.name}-${var.project}-ng"
  env                = var.env
  project            = var.project
  location           = var.location
  description        = "node group role"
  assume_role_policy = data.aws_iam_policy_document.node_group_assume_role.json
}

locals {
  node_group_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

module "node_group_role_attachment" {
  source     = "../../core_modules/iam_role_policy_attachment"
  count      = length(local.node_group_policies)
  policy_arn = local.node_group_policies[count.index]
  role       = module.node_group_role.iam_role_name
}