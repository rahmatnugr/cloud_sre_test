terraform {
  required_version = ">= 0.12, < 0.13"

  backend "s3" {
    bucket  = var.remote_state_bucket
    key     = "data-stores.tfstate"
    encrypt = true
    region  = var.aws_region
    profile = var.aws_profile
  }
}

provider "aws" {
  version = "~> 2.0"

  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "terraform_remote_state" "core_network" {
  backend = "s3"
  config = {
    bucket  = var.remote_state_bucket
    key     = "env:/${terraform.workspace}/core-network.tfstate"
    region  = var.aws_region
    profile = var.aws_profile
  }
}

# ----
# Subnets for data stores
# ----

module "priv_redis_subnet" {
  source = "../../modules/networking/subnet"

  name_prefix = "${terraform.workspace}_chatapp_priv_redis_subnet"
  cidr_blocks = var.priv_redis_subnet_cidr_blocks[terraform.workspace]
  azs         = data.aws_availability_zones.available.names
  vpc_id      = data.terraform_remote_state.core_network.outputs.vpc_id
  is_public   = false

  tags = {
    Group       = "chatapp_priv_redis_subnet"
    Environment = terraform.workspace
  }
}

module "priv_aurora_subnet" {
  source = "../../modules/networking/subnet"

  name_prefix = "${terraform.workspace}_chatapp_priv_aurora_subnet"
  cidr_blocks = var.priv_aurora_subnet_cidr_blocks[terraform.workspace]
  azs         = data.aws_availability_zones.available.names
  vpc_id      = data.terraform_remote_state.core_network.outputs.vpc_id
  is_public   = false

  tags = {
    Group       = "chatapp_priv_aurora_subnet"
    Environment = terraform.workspace
  }
}

# Concat all subnets in datastores
locals {
  datastore_subnet_ids = concat(module.priv_redis_subnet.subnet_ids, module.priv_aurora_subnet.subnet_ids)
}

# Associate all subnets with private subnet's route table
resource "aws_route_table_association" "data_stores" {
  count = length(local.datastore_subnet_ids)

  subnet_id      = local.datastore_subnet_ids[count.index]
  route_table_id = data.terraform_remote_state.core_network.outputs.private_route_id
}


# ----
# Security Group for data stores
# ----

module "redis_sg" {
  source = "../../modules/networking/security-group"

  name   = "${terraform.workspace}_chatapp_redis_sg"
  vpc_id = data.terraform_remote_state.core_network.outputs.vpc_id

  rules = [
    {
      type                     = "ingress"
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      cidr_blocks              = null
      self                     = null
      source_security_group_id = data.terraform_remote_state.core_network.outputs.fargate_sg_id
      description              = "Ingress for Redis"
    },
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      self                     = null
      source_security_group_id = null
      description              = "Public egress for Aurora"
    }
  ]
}

module "aurora_sg" {
  source = "../../modules/networking/security-group"

  name   = "${terraform.workspace}_chatapp_aurora_sg"
  vpc_id = data.terraform_remote_state.core_network.outputs.vpc_id

  rules = [
    {
      type                     = "ingress"
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      cidr_blocks              = null
      self                     = null
      source_security_group_id = data.terraform_remote_state.core_network.outputs.fargate_sg_id
      description              = "Ingress for Aurora"
    },
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      self                     = null
      source_security_group_id = null
      description              = "Public egress for Aurora"
    }
  ]
}

# ----
# Redis Cluster
# ----

module "redis_cluster" {
  source = "../../modules/data-stores/elasticache"

  name_prefix = "${terraform.workspace}-chatapp"

  subnet_ids         = module.priv_redis_subnet.subnet_ids
  availability_zones = data.aws_availability_zones.available.names
  security_group_ids = [module.redis_sg.id]

  tags = {
    Environment = terraform.workspace
  }
}

# ----
# Aurora MySQL Cluster
# ----

module "aurora_cluster" {
  source = "../../modules/data-stores/aurora"

  name_prefix = "${terraform.workspace}-chatapp"

  subnet_ids         = module.priv_aurora_subnet.subnet_ids
  availability_zones = data.aws_availability_zones.available.names
  security_group_ids = [module.aurora_sg.id]

  db_name            = var.aurora_db_name
  db_master_username = var.aurora_db_master_username
  db_master_password = var.aurora_db_master_password

  tags = {
    Environment = terraform.workspace
  }
}

# ----
# S3 Bucket for static frontend
# ----

module "s3_www" {
  source = "../../modules/data-stores/s3-www"

  bucket_name = replace("${terraform.workspace}-chatapp-${var.domain_name}", ".", "")
  aws_region  = var.aws_region

  tags = {
    Environment = terraform.workspace
  }
}
