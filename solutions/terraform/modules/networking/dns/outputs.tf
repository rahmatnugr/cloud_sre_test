output "zone_id" {
  value = aws_route53_zone.dns.zone_id
}

output "name_servers" {
  value = aws_route53_zone.dns.name_servers
}
