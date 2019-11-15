terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.name_prefix}_aurora_subnet_group"
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name = "${var.name_prefix}_aurora_subnet_group"
    },
    var.tags
  )

}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "${var.name_prefix}-aurora"

  engine         = var.engine
  engine_version = var.engine_version
  # engine_mode    = "serverless"

  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  availability_zones     = var.availability_zones
  vpc_security_group_ids = var.security_group_ids

  database_name                = var.db_name
  master_username              = var.db_master_username
  master_password              = var.db_master_password
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  final_snapshot_identifier    = "${var.name_prefix}-aurora"

  lifecycle {
    create_before_destroy = true
  }

  # scaling_configuration {
  #   auto_pause               = var.auto_pause
  #   max_capacity             = var.max_capacity
  #   min_capacity             = var.min_capacity
  #   seconds_until_auto_pause = var.seconds_until_auto_pause
  #   timeout_action           = var.timeout_action
  # }

  tags = merge(
    {
      Name = "${var.name_prefix}-aurora"
    },
    var.tags
  )
}

resource "aws_rds_cluster_instance" "aurora" {

  count = length(var.subnet_ids)

  engine               = var.engine
  engine_version       = var.engine_version
  identifier           = "${var.name_prefix}-aurora-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.aurora.id
  instance_class       = var.instance_class
  db_subnet_group_name = aws_db_subnet_group.aurora.name
  publicly_accessible  = var.publicly_accessible

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name  = "${var.name_prefix}-aurora-instance-${count.index}"
      Group = "${var.name_prefix}-aurora"
    },
    var.tags
  )
}
