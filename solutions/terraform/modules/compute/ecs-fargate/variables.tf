variable "name_prefix" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "container_definitions" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "target_group_arn" {
  type = string
}

variable "container_name" {
  type    = string
  default = ""
}

variable "app_port" {
  type = number
}

variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "tags" {
  type    = map
  default = {}
}
