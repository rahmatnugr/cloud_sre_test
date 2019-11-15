variable "registry_name" {
  type = string
}

variable "image_mutability" {
  type    = string
  default = "MUTABLE"
}

variable "tags" {
  type    = map
  default = {}
}
