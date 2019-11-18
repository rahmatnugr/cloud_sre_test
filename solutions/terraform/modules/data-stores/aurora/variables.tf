variable "name_prefix" {
  type = string
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "availability_zones" {
  type    = list(string)
  default = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "engine" {
  type    = string
  default = "aurora-mysql"
}

variable "engine_version" {
  type    = string
  default = "5.7.12"
}

variable "db_name" {
  type = string
}

variable "db_master_username" {
  type = string
}

variable "db_master_password" {
  type = string
}

variable "backup_retention_period" {
  type    = number
  default = 14
}

variable "preferred_backup_window" {
  type    = string
  default = "07:30-08:30"
}

variable "preferred_maintenance_window" {
  type    = string
  default = "wed:08:30-wed:09:30"
}

variable "auto_pause" {
  type    = bool
  default = true
}

variable "max_capacity" {
  type    = number
  default = 64
}

variable "min_capacity" {
  type    = number
  default = 2
}

variable "seconds_until_auto_pause" {
  type    = number
  default = 300
}

variable "timeout_action" {
  type    = string
  default = "ForceApplyCapacityChange"
}

variable "instance_class" {
  type    = string
  default = "db.t2.small"
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map
  default = {}
}
