output "id" {
  value = aws_alb.alb.id
}

output "arn" {
  value = aws_alb.alb.arn
}

output "dns_name" {
  value = aws_alb.alb.dns_name
}

output "target_group_arn" {
  value = aws_alb_target_group.target_group.arn
}
