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
  type = list(object({
    domain_name            = string
    origin_id              = string
    origin_protocol_policy = string
  }))
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
  type = list(object({
    path_pattern           = string
    viewer_protocol_policy = string
    cache_compress         = bool
    allowed_methods        = list(string)
    cached_methods         = list(string)
    target_origin_id       = string
    min_ttl                = number
    default_ttl            = number
    max_ttl                = number
    forward_query_string   = bool
    forward_cookies        = string
  }))
}

variable "tags" {
  type    = map
  default = {}
}


