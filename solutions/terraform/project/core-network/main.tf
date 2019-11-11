terraform {
  required_version = ">= 0.12, < 0.13"

  backend "s3" {
    bucket  = var.remote_state_bucket
    key     = "core-network.tfstate"
    encrypt = true
    region  = var.aws_region
    profile = var.aws_profile
  }
}

provider "aws" {
  version = "~> 2.0"

  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../modules/networking/vpc"

  cidr_block = var.cidr[terraform.workspace]
  name       = "${terraform.workspace}_chatapp_vpc"

  tags = {
    Environment = terraform.workspace
  }
}

module "gw" {
  source = "../../modules/networking/gateway"

  igw_name          = "${terraform.workspace}_chatapp_igw"
  natgw_name        = "${terraform.workspace}_chatapp_natgw"
  natgw_subnet_cidr = var.natgw_subnet_cidr[terraform.workspace]
  vpc_id            = module.vpc.id

  tags = {
    Environment = terraform.workspace
  }
}

module "pub_subnet" {
  source = "../../modules/networking/subnet"

  name_prefix = "${terraform.workspace}_chatapp_pub_subnet"
  cidr_blocks = var.pub_subnet_cidr_blocks[terraform.workspace]
  azs         = data.aws_availability_zones.available.names
  vpc_id      = module.vpc.id
  is_public   = true

  tags = {
    Group       = "chatapp_pub_subnet"
    Environment = terraform.workspace
  }
}

module "priv_fargate_subnet" {
  source = "../../modules/networking/subnet"

  name_prefix = "${terraform.workspace}_chatapp_priv_fargate_subnet"
  cidr_blocks = var.priv_fargate_subnet_cidr_blocks[terraform.workspace]
  azs         = data.aws_availability_zones.available.names
  vpc_id      = module.vpc.id
  is_public   = false

  tags = {
    Group       = "chatapp_pub_subnet"
    Environment = terraform.workspace
  }
}

module "routing" {
  source = "../../modules/networking/route"

  is_igw             = true
  igw_id             = module.gw.igw_id
  igw_route_table_id = module.gw.route_table_public
  igw_subnet_ids     = module.pub_subnet.subnet_ids

  is_natgw             = true
  natgw_id             = module.gw.natgw_id
  natgw_route_table_id = module.gw.route_table_private
  natgw_subnet_ids     = module.priv_fargate_subnet.subnet_ids
}

module "alb_sg" {
  source = "../../modules/networking/security-group"

  name   = "${terraform.workspace}_chatapp_alb_sg"
  vpc_id = module.vpc.id

  rules = [
    {
      type                     = "ingress"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      cidr_blocks              = ["0.0.0.0/0"]
      self                     = null
      source_security_group_id = null
      description              = "Public ingress for ALB"
    }
  ]
}

module "alb" {
  source = "../../modules/networking/alb"

  name_prefix = "${terraform.workspace}-chatapp"

  vpc_id          = module.vpc.id
  security_groups = [module.alb_sg.id]
  subnets         = module.pub_subnet.subnet_ids

  is_stickiness = true

  tags = {
    Environment = terraform.workspace
  }
}
