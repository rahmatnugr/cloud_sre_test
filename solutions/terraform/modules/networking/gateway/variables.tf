variable "igw_name" {
  type = string
}

variable "natgw_name" {
  type = string
}

variable "natgw_subnet_cidr" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map
}
