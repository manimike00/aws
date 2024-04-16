# security group for kube api-server
module "security_group" {
  source      = "../../core_modules/security_group"
  name        = "${var.env}-${var.name}-${var.project}"
  env         = var.env
  project     = var.project
  location    = var.location
  description = "kubernetes api-server security group"
  vpc_id      = var.vpc_id
  inbound_ports = [80,443]
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "TCP"
}

module "eks" {
  source                  = "../../core_modules/elastic_kubernetes_service"
  depends_on              = [module.eks_role_attachment]
  name                    = "${var.env}-${var.name}-${var.project}"
  env                     = var.env
  project                 = var.project
  location                = var.location
  endpoint_private_access = true
  endpoint_public_access  = false
  k8s_version             = "1.29"
  role_arn                = module.eks_role.iam_role_arn
  security_group_ids      = [module.security_group.security_group_id]
  subnet_ids              = var.subnet_ids
}

module "node_group_v1" {
  source         = "../../core_modules/eks_node_group"
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
  subnet_ids     = var.subnet_ids
  capacity_type  = "SPOT"
}

## ec2 server for accessing private eks
#module "ec2_role" {
#  source             = "../../core_modules/iam_role"
#  name               = "${var.env}-${var.name}-${var.project}-bastion"
#  env                = var.env
#  project            = var.project
#  location           = var.location
#  description        = "SSM role for ec2 instance"
#  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
#}

#module "ec2_role_attachment" {
#  source     = "../../core_modules/iam_role_policy_attachment"
#  role       = module.ec2_role.iam_role_name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#}

#module "ec2_sg" {
#  source      = "../../core_modules/security_group"
#  description = "security group for bastion server"
#  name        = "${var.env}-${var.name}-${var.project}-bastion"
#  env         = var.env
#  project     = var.project
#  location    = var.location
#  vpc_id      = var.vpc_id
#}

#module "bastion" {
#  source          = "../../core_modules/ec2"
#  name            = "${var.env}-${var.name}-${var.project}"
#  env             = var.env
#  project         = var.project
#  location        = var.location
#  role            = module.ec2_role.iam_role_name
#  security_groups = [module.ec2_sg.security_group_id]
#  subnet_id       = module.subnets[1].subnet_id[0]
#  user_data       = null
#  ami             = "ami-0a72af05d27b49ccb"
#}

# openid provider
module "eks_openid" {
  source          = "../../core_modules/iam_openid_connect_provider"
  openid_url      = module.eks.cluster_openid_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.openid.certificates.0.sha1_fingerprint]
}

#module "eks_alb_role" {
#  source             = "../../core_modules/iam_role"
#  name               = "${var.env}-${var.name}-${var.project}-eks-alb"
#  env                = var.env
#  project            = var.project
#  location           = var.location
#  description        = "load balancer role for eks"
#  assume_role_policy = data.template_file.lb_trust_policy.rendered
#}
#module "eks_alb_policy" {
#  source      = "../../core_modules/iam_policy"
#  name        = "${var.env}-${var.name}-${var.project}-eks-alb"
#  env         = var.env
#  project     = var.project
#  location    = var.location
#  description = "load balancer role for eks"
#  policy      = data.template_file.lb_policy.rendered
#}
#module "eks_lb_role_attachment" {
#  source     = "../../core_modules/iam_role_policy_attachment"
#  role       = module.eks_alb_role.iam_role_name
#  policy_arn = module.eks_alb_policy.policy_arn
#}


