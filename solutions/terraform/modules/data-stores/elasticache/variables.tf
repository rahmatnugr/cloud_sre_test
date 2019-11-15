variable "name_prefix" {
  type = string
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "family" {
  type    = string
  default = "redis5.0"
}

variable "parameters" {
  type = list(map(string))
  default = [
    {
      name  = "cluster-enabled"
      value = "yes"
    }
  ]
}

variable "replication_group_id" {
  type    = string
  default = ""
}

variable "replication_group_description" {
  type    = string
  default = ""
}

variable "node_type" {
  type    = string
  default = "cache.t2.small"
}

variable "port" {
  type    = number
  default = 6379
}

variable "automatic_failover_enabled" {
  type    = bool
  default = true
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
  default = "redis"
}

variable "engine_version" {
  type    = string
  default = "5.0.3"
}

variable "at_rest_encryption_enabled" {
  type    = bool
  default = true
}

variable "transit_encryption_enabled" {
  type    = bool
  default = true
}

variable "snapshot_window" {
  type    = string
  default = "07:30-08:30"
}

variable "snapshot_retention_limit" {
  type    = number
  default = 0
}

variable "replicas_per_node_group" {
  type    = number
  default = 1
}

variable "num_node_groups" {
  type    = number
  default = 1
}

variable "tags" {
  type    = map
  default = {}
}
