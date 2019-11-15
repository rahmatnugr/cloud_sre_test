variable "name_prefix" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "cert_validation_method" {
  type    = string
  default = "DNS"
}

variable "domain_name" {
  type = string
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "origins" {
  type = list(map())
}

variable "viewer_protocol_policy" {
  type    = string
  default = "redirect-to-https"
}

variable "cache_compress" {
  type    = bool
  default = true
}

variable "allowed_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "s3www_domain_name" {
  type = string
}

variable "default_cache_min_ttl" {
  type    = number
  default = 0
}

variable "default_cache_default_ttl" {
  type    = number
  default = 86400
}

variable "default_cache_max_ttl" {
  type    = number
  default = 31536000
}

variable "ordered_cache_behaviors" {
  type = list(map())
}

variable "tags" {
  type    = map
  default = {}
}


