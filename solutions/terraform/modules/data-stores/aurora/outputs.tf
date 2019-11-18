output "arn" {
  value = aws_rds_cluster.aurora.arn
}

output "endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

output "reader_endpoint" {
  value = aws_rds_cluster.aurora.reader_endpoint
}

output "database_name" {
  value = aws_rds_cluster.aurora.database_name
}

output "master_username" {
  value = aws_rds_cluster.aurora.master_username
}
