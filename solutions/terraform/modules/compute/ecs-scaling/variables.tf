variable "name_prefix" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "min_capacity" {
  type    = number
  default = 2
}

variable "max_capacity" {
  type    = number
  default = 3
}

variable "high_cpu_threshold" {
  type    = number
  default = 75
}

variable "low_cpu_threshold" {
  type    = number
  default = 10
}

variable "tags" {
  type    = map
  default = {}
}
