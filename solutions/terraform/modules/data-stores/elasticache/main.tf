terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_elasticache_subnet_group" "cache" {
  name       = "${var.name_prefix}-elasticache-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "cache" {
  name = "${var.name_prefix}-elasticache-parameter-group"

  family = var.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_elasticache_replication_group" "cache" {

  replication_group_id          = var.replication_group_id == "" ? "${var.name_prefix}-${var.engine}-replica-group" : var.replication_group_id
  replication_group_description = var.replication_group_description
  node_type                     = var.node_type
  port                          = var.port
  parameter_group_name          = aws_elasticache_parameter_group.cache.name
  automatic_failover_enabled    = var.automatic_failover_enabled
  engine                        = var.engine
  engine_version                = var.engine_version
  subnet_group_name             = aws_elasticache_subnet_group.cache.name
  security_group_ids            = var.security_group_ids
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  # availability_zones            = var.availability_zones
  # number_cache_clusters         = length(var.availability_zones)


  cluster_mode {
    replicas_per_node_group = var.replicas_per_node_group
    num_node_groups         = var.num_node_groups
  }

  tags = merge(
    {
      Name = "${var.name_prefix}_elasticache_replica_group"
    },
    var.tags
  )
}
