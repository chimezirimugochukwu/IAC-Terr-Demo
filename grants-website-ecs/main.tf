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
  private_app_subnet1_cidr      = var.private_app_subnet1_cidr
  private_app_subnet2_cidr      = var.private_app_subnet2_cidr
  private_data_subnet1_cidr     = var.private_data_subnet1_cidr
  private_data_subnet2_cidr     = var.private_data_subnet2_cidr     
}