variable "name_prefix" {
  type    = string
  default = "default"
}

variable "vpc_id" {
  type = string
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "is_internal" {
  type    = bool
  default = false
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "subnets" {
  type    = list(string)
  default = []
}

variable "is_logs" {
  type    = bool
  default = false
}

variable "logs_bucket" {
  type    = string
  default = "alb-logs-bucket"
}

variable "logs_prefix" {
  type    = string
  default = "alb"
}

variable "tags" {
  type    = map
  default = {}
}

variable "target_group_type" {
  type    = string
  default = "ip"
}

variable "target_group_port" {
  type    = number
  default = 80
}

variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}

variable "is_stickiness" {
  type    = bool
  default = false
}

variable "stickiness_cookie_duration" {
  type    = number
  default = 86400
}

variable "is_healthcheck" {
  type    = bool
  default = true
}

variable "healthcheck_interval" {
  type    = number
  default = 30
}

variable "healthcheck_path" {
  type    = string
  default = "/"
}

variable "healthcheck_port" {
  type    = number
  default = 80
}

variable "healthcheck_protocol" {
  type    = string
  default = "HTTP"
}

variable "healthcheck_timeout" {
  type    = number
  default = 10
}

variable "healthcheck_healthy_threshold" {
  type    = number
  default = 3
}

variable "healthcheck_unhealthy_threshold" {
  type    = number
  default = 3
}

variable "healthcheck_matcher" {
  type    = string
  default = "200"
}

variable "app_port" {
  type    = number
  default = 80
}

variable "app_protocol" {
  type    = string
  default = "HTTP"
}
