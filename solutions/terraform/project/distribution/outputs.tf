# ----
# CDN related output
# ----
output "cdn_id" {
  value = module.cdn.cdn_id
}

output "cdn_arn" {
  value = module.cdn.cdn_arn
}

output "cdn_domain_name" {
  value = module.cdn.cdn_domain_name
}

# ----
# DNS related output
# ----
output "dns_zone_id" {
  value = module.dns.zone_id
}

output "dns_name_servers" {
  value = module.dns.name_servers
}
