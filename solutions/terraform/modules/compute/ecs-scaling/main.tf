terraform {
  required_version = ">= 0.12, < 0.13"
}

locals {
  resource_id = "service/${var.cluster_name}/${var.service_name}"
}

# ----
# ECS Autoscaling target
# ----
resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = local.resource_id
  scalable_dimension = "ecs:service:DesiredCount"

  min_capacity = var.min_capacity
  max_capacity = var.max_capacity
}

# Scale out handler
resource "aws_appautoscaling_policy" "scale_out" {
  name = "${var.name_prefix}_scale_out_policy"

  service_namespace  = "ecs"
  resource_id        = local.resource_id
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name = "${var.name_prefix}_cpu_high"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_cpu_threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_out.arn]

  tags = merge(
    {
      Name = "${var.name_prefix}_cpu_high"
    },
    var.tags
  )
}

# ----
# Scale in handler
# ----
resource "aws_appautoscaling_policy" "scale_in" {
  name = "${var.name_prefix}_scale_in"

  service_namespace  = "ecs"
  resource_id        = local.resource_id
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name = "${var.name_prefix}_cpu_low"

  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_cpu_threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_in.arn]

  tags = merge(
    {
      Name = "${var.name_prefix}_cpu_low"
    },
    var.tags
  )
}
