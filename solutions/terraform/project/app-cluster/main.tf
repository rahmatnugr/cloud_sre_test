terraform {
  required_version = ">= 0.12, < 0.13"

  backend "s3" {
    bucket  = var.remote_state_bucket
    key     = "app-cluster.tfstate"
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

# ----
# Remote state
# ----
data "terraform_remote_state" "core_network" {
  backend = "s3"
  config = {
    bucket  = var.remote_state_bucket
    key     = "env:/${terraform.workspace}/core-network.tfstate"
    region  = var.aws_region
    profile = var.aws_profile
  }
}

data "terraform_remote_state" "data_stores" {
  backend = "s3"
  config = {
    bucket  = var.remote_state_bucket
    key     = "env:/${terraform.workspace}/data-stores.tfstate"
    region  = var.aws_region
    profile = var.aws_profile
  }
}

# ----
# Reusable variable
# ----
locals {
  name_prefix = "${terraform.workspace}_chatapp"
}

# ---- 
# ECR 
# ----
module "registry" {
  source = "../../modules/compute/ecr"

  registry_name = "${terraform.workspace}_chatapp_backend"
}

# ----
# ECS Fargate related resource
# ----
## TODO: env var from datastore
data "template_file" "fargate" {
  template = file("./template-fargate-chatapp.json.tpl")

  vars = {
    app_name            = "${terraform.workspace}_chatapp_backend"
    app_image           = module.registry.repository_url
    app_port            = var.app_port
    cpu                 = var.cpu
    memory              = var.memory
    aws_region          = var.aws_region
    mysql_host          = data.terraform_remote_state.data_stores.outputs.aurora_endpoint
    mysql_host_readonly = data.terraform_remote_state.data_stores.outputs.aurora_reader_endpoint
    mysql_username      = var.mysql_username
    mysql_password      = var.mysql_password
    redis_host          = data.terraform_remote_state.data_stores.outputs.redis_configuration_endpoint_address
  }
}

module "app_cluster" {
  source = "../../modules/compute/ecs-fargate"

  name_prefix           = local.name_prefix
  cpu                   = var.cpu
  memory                = var.memory
  container_definitions = data.template_file.fargate.rendered
  desired_count         = var.desired_count
  target_group_arn      = data.terraform_remote_state.core_network.outputs.alb_target_group_arn
  container_name        = "${terraform.workspace}_chatapp_backend"
  app_port              = var.app_port
  security_groups       = [data.terraform_remote_state.core_network.outputs.fargate_sg_id]
  subnets               = data.terraform_remote_state.core_network.outputs.priv_fargate_subnet_ids

  # tags = {
  #   Environment = terraform.workspace
  # }
}

module "app_cluster_scaling" {
  source = "../../modules/compute/ecs-scaling"

  name_prefix        = local.name_prefix
  cluster_name       = module.app_cluster.cluster_name
  service_name       = module.app_cluster.service_name
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  high_cpu_threshold = var.high_cpu_threshold
  low_cpu_threshold  = var.low_cpu_threshold

  tags = {
    Environment = terraform.workspace
  }
}

