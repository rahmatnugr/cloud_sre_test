output "scaling_policy_scale_out_arn" {
  value = aws_appautoscaling_policy.scale_out.arn
}

output "scaling_policy_scale_out_name" {
  value = aws_appautoscaling_policy.scale_out.name
}

output "scaling_policy_scale_in_arn" {
  value = aws_appautoscaling_policy.scale_in.arn
}

output "scaling_policy_scale_in_name" {
  value = aws_appautoscaling_policy.scale_in.name
}

output "metric_alarm_cpu_high_arn" {
  value = aws_cloudwatch_metric_alarm.cpu_high.arn
}

output "metric_alarm_cpu_high_id" {
  value = aws_cloudwatch_metric_alarm.cpu_high.id
}

output "metric_alarm_cpu_low_arn" {
  value = aws_cloudwatch_metric_alarm.cpu_low.arn
}

output "metric_alarm_cpu_low_id" {
  value = aws_cloudwatch_metric_alarm.cpu_low.id
}
