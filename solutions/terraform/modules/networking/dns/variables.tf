variable "name_prefix" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "dns_records" {
  type = list(object({
    name    = string
    type    = string
    records = list(string)
  }))
}

variable "ttl" {
  type    = string
  default = "60"
}

variable "tags" {
  type    = map
  default = {}
}
