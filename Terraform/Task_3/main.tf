provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
}

module "internet_gateway" {
  source              = "./modules/internet_gateway"
  vpc_id              = module.vpc.vpc_id
}

module "nat_gateway" {
  source              = "./modules/nat_gateway"
  public_subnet_id    = module.subnets.public_subnet_ids[0]
}

module "route_tables" {
  source                = "./modules/route_tables"
  vpc_id                = module.vpc.vpc_id
  internet_gateway_id   = module.internet_gateway.internet_gateway_id
  nat_gateway_id        = module.nat_gateway.nat_gateway_id
  pub_subnets       = module.subnets.public_subnet_ids
  pvt_subnets       = module.subnets.private_subnet_ids
}

module "security_groups" {
  source                  = "./modules/security_groups"
  vpc_id                  = module.vpc.vpc_id
}


module "target_groups" {
  source                  = "./modules/target_groups"
  vpc_id                  = module.vpc.vpc_id
}

module "load_balancers" {
  depends_on              = [module.target_groups]
  source                  = "./modules/load_balancers"
  public_subnet_ids       = module.subnets.public_subnet_ids
  public_security_group_id   = module.security_groups.public_security_group_id
  private_subnet_ids       = module.subnets.private_subnet_ids
  private_security_group_id   = module.security_groups.private_security_group_id
  pub_tg = module.target_groups.public_target_group_arn
  pvt_tg = module.target_groups.private_target_group_arn
}

module "ec2_instances" {
  depends_on              = [module.load_balancers.private_load_balancer_dns]
  source                  = "./modules/ec2_instances"
  public_subnet_ids       = module.subnets.public_subnet_ids
  private_subnet_ids      = module.subnets.private_subnet_ids
  public_security_group_id   = module.security_groups.public_security_group_id
  private_security_group_id  = module.security_groups.private_security_group_id
  private_load_balancer_dns = module.load_balancers.private_load_balancer_dns
  pub_tg_rg = module.target_groups.public_target_group_arn
  pvt_tg_rg = module.target_groups.private_target_group_arn
}

