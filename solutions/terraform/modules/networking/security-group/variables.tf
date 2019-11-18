variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Security Group"
}

variable "vpc_id" {
  type = string
}

variable "rules" {
  type = list(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    self                     = bool
    cidr_blocks              = list(string)
    source_security_group_id = string
    description              = string
  }))
}

variable "tags" {
  type    = map
  default = {}
}
