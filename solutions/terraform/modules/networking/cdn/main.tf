terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.root_domain_name}"
  validation_method = var.cert_validation_method

  subject_alternative_names = ["${var.root_domain_name}"]

  tags = merge(
    {
      Name = "${var.name_prefix}_acm_cert"
    },
    var.tags
  )
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = var.default_root_object

  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
    }

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = origin.value.origin_protocol_policy
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = var.viewer_protocol_policy
    compress               = var.cache_compress
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = var.s3www_domain_name
    min_ttl                = var.default_cache_min_ttl
    default_ttl            = var.default_cache_default_ttl
    max_ttl                = var.default_cache_max_ttl

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors
    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      compress               = ordered_cache_behavior.value.cache_compress
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl

      forwarded_values {
        query_string = ordered_cache_behavior.value.forward_query_string
      }
    }
  }

  aliases = [var.domain_name]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.certificate.arn}"
    ssl_support_method  = "sni-only"
  }

  tags = merge(
    {
      Name = "${var.name_prefix}_cf"
    },
    var.tags
  )
}
