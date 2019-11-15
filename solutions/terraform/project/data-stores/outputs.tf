# ----
# Aurora related output
# ----
output "aurora_arn" {
  value = module.aurora_cluster.arn
}

output "aurora_endpoint" {
  value = module.aurora_cluster.endpoint
}

output "aurora_reader_endpoint" {
  value = module.aurora_cluster.reader_endpoint
}

output "aurora_database_name" {
  value = module.aurora_cluster.database_name
}

output "aurora_master_username" {
  value = module.aurora_cluster.master_username
}

# ----
# Redis related output
# ----
output "redis_id" {
  value = module.redis_cluster.id
}

output "redis_configuration_endpoint_address" {
  value = module.redis_cluster.configuration_endpoint_address
}

output "redis_primary_endpoint_address" {
  value = module.redis_cluster.primary_endpoint_address
}

# ----
# S3 related output
# ----
output "s3_www_id" {
  value = module.s3_www.id
}

output "s3_www_domain" {
  value = module.s3_www.bucket_domain_name
}

output "s3_www_arn" {
  value = module.s3_www.arn
}

output "s3_www_regional_domain" {
  value = module.s3_www.bucket_regional_domain_name
}

output "s3_www_web_endpoint" {
  value = module.s3_www.website_endpoint
}

output "s3_www_web_domain" {
  value = module.s3_www.website_domain
}
