variable "bucket_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "index_document" {
  type    = string
  default = "index.html"
}

variable "error_document" {
  type    = string
  default = "404.html"
}

variable "tags" {
  type    = map
  default = {}
}
