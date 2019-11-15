output "cluster_name" {
  value = "${var.name_prefix}_fargate_cluster"
}

output "cluster_id" {
  value = aws_ecs_cluster.fargate.id
}

output "cluster_arn" {
  value = aws_ecs_cluster.fargate.arn
}

output "task_arn" {
  value = aws_ecs_task_definition.fargate.arn
}

output "task_family" {
  value = aws_ecs_task_definition.fargate.family
}

output "service_id" {
  value = aws_ecs_service.fargate.id
}

output "service_name" {
  value = aws_ecs_service.fargate.name
}

output "service_iam_role_arn" {
  value = aws_ecs_service.fargate.iam_role
}
