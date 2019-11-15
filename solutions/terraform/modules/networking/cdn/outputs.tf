output "cert_id" {
  value = aws_acm_certificate.cert.id
}

output "cert_arn" {
  value = aws_acm_certificate.cert.arn
}

output "cert_domain_name" {
  value = aws_acm_certificate.cert.domain_name
}

output "cert_domain_validation" {
  value = aws_acm_certificate.cert.domain_validation_options
}

output "cert_validation_emails" {
  value = aws_acm_certificate.cert.validation_emails
}

output "cdn_id" {
  value = aws_cloudfront_distribution.cdn.id
}

output "cdn_arn" {
  value = aws_cloudfront_distribution.cdn.arn
}

output "cdn_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "cdn_hosted_zone_id" {
  value = aws_cloudfront_distribution.cdn.hosted_zone_id
}

