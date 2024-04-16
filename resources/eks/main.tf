module "eks" {
  source = "../../modules/service_modules/elastic_kubernetes_service"
  name         = "demo"
  env          = "dev"
  project      = "test"
  location     = "ap-southeast-1"
  vpc_id       = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids   = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}