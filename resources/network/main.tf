module "network" {
  source       = "../../modules/service_modules/vpc"
  name         = "demo"
  env          = "dev"
  project      = "aota"
  location     = "ap-southeast-1"
  cidr_block   = "10.13.0.0/16"
  public_cidr  = ["10.13.27.0/26", "10.13.27.64/26", "10.13.27.128/26"]
  private_cidr = ["10.13.0.0/21", "10.13.8.0/21", "10.13.16.0/21"]
  db_cidr      = ["10.13.24.0/24", "10.13.25.0/24", "10.13.26.0/24"]
}