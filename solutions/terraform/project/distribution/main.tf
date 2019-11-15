terraform {
  required_version = ">= 0.12, < 0.13"

  backend "s3" {
    bucket  = var.remote_state_bucket
    key     = "distribution.tfstate"
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
# Get some data from remote state
# ----
data "terraform_remote_state" "core_network" {
  backend = "s3"
  config = {
    bucket  = var.remote_state_bucket
    key     = "env:/${terraform.workspace}/core_network.tfstate"
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
  s3www_domain = data.terraform_remote_state.data_stores.outputs.s3_www_regional_domain
  alb_domain   = data.terraform_remote_state.core_network.outputs.alb_dns_name
}

# ----
# CDN Module
# Register S3 domain (frontend) and ALB (backend) as origin for CDN
# ----
module "cdn" {
  source = "../../modules/networking/cdn"

  name_prefix      = "${terraform.workspace}_chatapp"
  root_domain_name = var.domain_name
  domain_name      = var.domain_name
  origins = [
    {
      domain_name            = local.s3www_domain
      origin_id              = local.s3www_domain
      origin_protocol_policy = "http-only"
    },
    {
      domain_name            = local.alb_domain
      origin_id              = local.alb_domain
      origin_protocol_policy = "http-only"
    }
  ]
  s3www_domain_name = local.s3www_domain
  ordered_cache_behaviors = [
    {
      path_pattern           = "/api"
      viewer_protocol_policy = ""
      cache_compress         = true
      allowed_methods        = ["GET", "HEAD", "POST"]
      cached_methods         = ["GET", "HEAD", "POST"]
      target_origin_id       = local.alb_domain
      min_ttl                = 0
      default_ttl            = 0
      max_ttl                = 0
      query_string           = true
    },
    {
      path_pattern           = "/api/*"
      viewer_protocol_policy = ""
      cache_compress         = true
      allowed_methods        = ["GET", "HEAD", "POST"]
      cached_methods         = ["GET", "HEAD", "POST"]
      target_origin_id       = local.alb_domain
      min_ttl                = 0
      default_ttl            = 0
      max_ttl                = 0
      query_string           = true
    }
  ],

  tags = {
    Environment = terraform.workspace
  }
}

# ----
# DNS Module
# Register domain as alias of CDN domain, and register subdomain for certificate domain validation
# ----
module "dns" {
  source = "../../modules/networking/dns"

  name_prefix = "${terraform.workspace}_chatapp"
  root_domain_name = var.domain_name
  ttl = "30"
  
  dns_records = [
    {
      name = "*"
      type = "CNAME"
      records = [
        module.cdn.cdn_domain_name
      ]
    },
    {
      name = module.cdn.cert_domain_validation.resource_record_name
      type = module.cdn.cert_domain_validation.resource_record_type
      records = [module.cdn.cert_domain_validation.resource_record_value]
    }
  ]

  tags = {
    Environment = terraform.workspace
  }
}
