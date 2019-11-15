variable "name_prefix" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "dns_records" {
  type = list(map())
}

variable "tags" {
  type    = map
  default = {}
}
