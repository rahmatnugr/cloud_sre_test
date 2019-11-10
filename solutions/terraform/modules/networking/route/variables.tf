variable "is_natgw" {
  type    = bool
  default = false
}

variable "natgw_id" {
  type = string
}

variable "natgw_subnet_ids" {
  type    = list(string)
  default = []
}

variable "natgw_route_table_id" {
  type = string
}

variable "is_igw" {
  type    = bool
  default = false
}

variable "igw_id" {
  type = string
}

variable "igw_subnet_ids" {
  type    = list(string)
  default = []
}

variable "igw_route_table_id" {
  type = string
}
