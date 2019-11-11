terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_alb" "alb" {
  name = "${var.name_prefix}-alb"

  load_balancer_type = "application"
  internal           = var.is_internal
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = true

  access_logs {
    enabled = var.is_logs
    bucket  = var.logs_bucket
    prefix  = var.logs_prefix
  }

  tags = merge(
    {
      Name = "${var.name_prefix}_alb"
    },
    var.tags
  )
}

resource "aws_alb_target_group" "target_group" {
  name = "${var.name_prefix}-alb-target-group"

  target_type = var.target_group_type
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id

  stickiness {
    enabled         = var.is_stickiness
    type            = "lb_cookie"
    cookie_duration = var.stickiness_cookie_duration
  }

  health_check {
    enabled             = var.is_healthcheck
    interval            = var.healthcheck_interval
    path                = var.healthcheck_path
    port                = var.healthcheck_port
    protocol            = var.healthcheck_protocol
    timeout             = var.healthcheck_timeout
    healthy_threshold   = var.healthcheck_healthy_threshold
    unhealthy_threshold = var.healthcheck_unhealthy_threshold
    matcher             = var.healthcheck_matcher
  }

  tags = merge(
    {
      Name = "${var.name_prefix}-alb-target-group"
    },
    var.tags
  )
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.app_port
  protocol          = var.app_protocol

  default_action {
    target_group_arn = aws_alb_target_group.target_group.id
    type             = "forward"
  }
}


