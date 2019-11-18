output "id" {
  value = aws_s3_bucket.www.id
}

output "bucket_domain_name" {
  value = aws_s3_bucket.www.bucket_domain_name
}

output "arn" {
  value = aws_s3_bucket.www.arn
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.www.bucket_regional_domain_name
}

output "website_endpoint" {
  value = aws_s3_bucket.www.website_endpoint
}

output "website_domain" {
  value = aws_s3_bucket.www.website_domain
}
