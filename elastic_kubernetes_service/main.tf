# virtual private network (VPC)
module "vpc" {
  source               = "../modules/virtual_private_cloud"
  name                 = "${var.env}-${var.name}-${var.project}"
  env                  = var.env
  project              = var.project
  location             = var.location
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# private, public and db subnets
variable "types" {
  default = ["pub", "pri", "db"]
}
variable "subnet_range" {
  default = [10, 20, 30]
}
module "subnets" {
  source       = "../modules/subnets"
  count        = length(var.types)
  name         = "${var.env}-${var.name}-${var.project}-${var.types[count.index]}"
  env          = var.env
  project      = var.project
  location     = var.location
  vpc_id       = module.vpc.vpc_id
  cidr_block   = module.vpc.vpc_cidr_block
  subnet_range = var.subnet_range[count.index]
}

# internet gateway
module "internet_gateway" {
  source   = "../modules/internet_gateway"
  name     = "${var.env}-${var.name}-${var.project}"
  env      = var.env
  project  = var.project
  location = var.location
  vpc_id   = module.vpc.vpc_id
}

# elastic ip
module "elastic_ip" {
  source   = "../modules/elastic_ip"
  name     = "${var.env}-${var.name}-${var.project}"
  env      = var.env
  project  = var.project
  location = var.location
  vpc      = true
}

# nat gateway
module "nat_gateway" {
  source        = "../modules/nat_gateway"
  name          = "${var.env}-${var.name}-${var.project}"
  env           = var.env
  project       = var.project
  location      = var.location
  allocation_id = module.elastic_ip.elastic_id
  subnet_id     = module.subnets[0].subnet_id[0]
}

# route table setup
locals {
  route_tables = ["public", "private", "db"]
}

module "route_tables" {
  source         = "../modules/route_table"
  count          = length(local.route_tables)
  name           = "${var.env}-${var.name}-${var.project}-${local.route_tables[count.index]}"
  env            = var.env
  project        = var.project
  location       = var.location
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "0.0.0.0/0"
  type           = local.route_tables[count.index]
  gateway_id     = module.internet_gateway.internet_gateway_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}

module "rote_table_association" {
  source         = "../modules/route_table_association"
  count          = length(local.route_tables)
  route_table_id = module.route_tables[count.index].route_table_id[0]
  subnet_id      = module.subnets[count.index].subnet_id
}

# security group for kube apo-server
module "security_group" {
  source      = "../modules/security_group"
  name        = "${var.env}-${var.name}-${var.project}"
  env         = var.env
  project     = var.project
  location    = var.location
  description = "kubernetes api-server security group"
  vpc_id      = module.vpc.vpc_id
}

# elastic kubernetes service
module "eks_role" {
  source             = "../modules/iam_role"
  name               = "${var.env}-${var.name}-${var.project}"
  env                = var.env
  project            = var.project
  location           = var.location
  description        = "kubernetes api-server role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

locals {
  policies = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]
}

module "eks_role_attachment" {
  source     = "../modules/iam_role_policy_attachment"
  count      = length(local.policies)
  policy_arn = local.policies[count.index]
  role       = module.eks_role.iam_role_name
}

module "eks" {
  source                  = "../modules/elastic_kubernetes_service"
  depends_on              = [module.eks_role_attachment]
  name                    = "${var.env}-${var.name}-${var.project}"
  env                     = var.env
  project                 = var.project
  location                = var.location
  endpoint_private_access = true
  endpoint_public_access  = false
  k8s_version             = "1.25"
  role_arn                = module.eks_role.iam_role_arn
  security_group_ids      = [module.security_group.security_group_id]
  subnet_ids              = module.subnets[1].subnet_id
}

# node group
module "node_group_role" {
  source             = "../modules/iam_role"
  name               = "${var.env}-${var.name}-${var.project}-ng"
  env                = var.env
  project            = var.project
  location           = var.location
  description        = "node group role"
  assume_role_policy = data.aws_iam_policy_document.node_group_assume_role.json
}
locals {
  node_group_policies = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}

module "node_group_role_attachment" {
  source     = "../modules/iam_role_policy_attachment"
  count      = length(local.node_group_policies)
  policy_arn = local.node_group_policies[count.index]
  role       = module.node_group_role.iam_role_name
}

module "node_group" {
  source         = "../modules/eks_node_group"
  name           = "${var.env}-${var.name}-${var.project}"
  env            = var.env
  project        = var.project
  location       = var.location
  cluster_name   = module.eks.cluster_name
  desired_size   = 1
  max_size       = 1
  min_size       = 1
  disk_size      = 20
  instance_types = ["t3.medium"]
  node_role_arn  = module.node_group_role.iam_role_arn
  subnet_ids     = module.subnets[1].subnet_id
  capacity_type  = "SPOT"
}

# ec2 server for accessing private eks
module "ec2_role" {
  source             = "../modules/iam_role"
  name               = "${var.env}-${var.name}-${var.project}-bastion"
  env                = var.env
  project            = var.project
  location           = var.location
  description        = "SSM role for ec2 instance"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
module "ec2_role_attachment" {
  source     = "../modules/iam_role_policy_attachment"
  role       = module.ec2_role.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
module "ec2_sg" {
  source      = "../modules/security_group"
  description = "security group for bastion server"
  name        = "${var.env}-${var.name}-${var.project}-bastion"
  env         = var.env
  project     = var.project
  location    = var.location
  vpc_id      = module.vpc.vpc_id
}

module "bastion" {
  source          = "../modules/ec2"
  name            = "${var.env}-${var.name}-${var.project}"
  env             = var.env
  project         = var.project
  location        = var.location
  role            = module.ec2_role.iam_role_name
  security_groups = [module.ec2_sg.security_group_id]
  subnet_id       = module.subnets[1].subnet_id[0]
  user_data       = null
  ami             = "ami-0a72af05d27b49ccb"
}

# openid provider
module "eks_openid" {
  source          = "../modules/iam_openid_connect_provider"
  openid_url      = module.eks.cluster_openid_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.openid.certificates.0.sha1_fingerprint]
}

module "eks_alb_role" {
  source             = "../modules/iam_role"
  name               = "${var.env}-${var.name}-${var.project}-eks-alb"
  env                = var.env
  project            = var.project
  location           = var.location
  description        = "load balancer role for eks"
  assume_role_policy = data.template_file.lb_trust_policy.rendered
}
module "eks_alb_policy" {
  source      = "../modules/iam_policy"
  name        = "${var.env}-${var.name}-${var.project}-eks-alb"
  env         = var.env
  project     = var.project
  location    = var.location
  description = "load balancer role for eks"
  policy      = data.template_file.lb_policy.rendered
}
module "eks_lb_role_attachment" {
  source     = "../modules/iam_role_policy_attachment"
  role       = module.eks_alb_role.iam_role_name
  policy_arn = module.eks_alb_policy.policy_arn
}


