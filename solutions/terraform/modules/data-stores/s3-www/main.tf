terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_s3_bucket" "www" {
  bucket = var.bucket_name
  region = var.aws_region

  acl = "public-read"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.bucket_name}/*"]
    }
  ]
}
POLICY

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  tags = merge(
    {
      Name = var.bucket_name
    },
    var.tags
  )
}
