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

# create iam role

module "ecs-task-execution-role" {
  source        = "../modules/ecs-task-execution-role"
  project_name  = module.vpc.project_name
}

# get an ssl certificate 

module "acm" {
  source            = "../modules/aws-certificate-manager"
  domain_name       = var.domain_name
  alternative_name  = var.alternative_name
}

# create an application load balancer

module "alb" {
  source                = "../modules/alb"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.securtiy-group.alb_security_group_id
  public_subnet1_id     = module.vpc.public_subnet1_id
  public_subnet2_id     = module.vpc.public_subnet2_id
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.acm.certificate_arn   
}

# creates the ECS Fargate

module "ecs" {
  source                      = "../modules/ecs"
  project_name                = module.vpc.project_name
  ecs_task_execution_role_arn = module.ecs-task-execution-role.ecs_task_execution_role_arn
  container_image             = var.container_image
  region                      = module.vpc.region
  private_app_subnet1_id      = module.vpc.private_app_subnet1_id
  private_app_subnet2_id      = module.vpc.private_app_subnet2_id
  ecs_security_group_id       = module.securtiy-group.ecs_security_group_id
  alb_target_group_arn        = module.alb.alb_target_group_arn
}