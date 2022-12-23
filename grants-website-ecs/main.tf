# configure aws provider 
provider "aws" {
  region    = var.region
  profile   = "default"
}

# create vpc
module "vpc" {
  source                        = "../modules/vpc"
  region                        = var.region
  project_name                  = var.project_name
  vpc_cidr                      = var.vpc_cidr
  public_subnet1_cidr           = var.public_subnet1_cidr
  public_subnet2_cidr           = var.public_subnet2_cidr
  private_app_subnet1_cidr      = var.private_app_subnet1_cidr
  private_app_subnet2_cidr      = var.private_app_subnet2_cidr
  private_data_subnet1_cidr     = var.private_data_subnet1_cidr
  private_data_subnet2_cidr     = var.private_data_subnet2_cidr     
}

# createv nat-gateway

module "nat-gateway" {
  source                      = "../modules/nat-gateway"
  public_subnet1_id           = module.vpc.public_subnet1_id
  public_subnet2_id           = module.vpc.public_subnet2_id
  internet_gateway            = module.vpc.internet_gateway
  vpc_id                      = module.vpc.vpc_id
  private_app_subnet1_id      = module.vpc.private_app_subnet1_id
  private_data_subnet1_id     = module.vpc.private_data_subnet1_id
  private_app_subnet2_id      = module.vpc.private_app_subnet2_id
  private_data_subnet2_id     = module.vpc.private_data_subnet2_id
}

# create security groups

module "securtiy-group" {
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}