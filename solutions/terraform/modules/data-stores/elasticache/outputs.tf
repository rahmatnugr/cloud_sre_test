output "id" {
  value = aws_elasticache_replication_group.cache.id
}

output "configuration_endpoint_address" {
  value = aws_elasticache_replication_group.cache.configuration_endpoint_address
}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.cache.primary_endpoint_address
}
