output "arn" {
  value = aws_ecr_repository.registry.arn
}

output "id" {
  value = aws_ecr_repository.registry.registry_id
}

output "repository_url" {
  value = aws_ecr_repository.registry.repository_url
}
