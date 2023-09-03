output "cloudfront_endpoint" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "bucket_regional_domain_name" {
  value = local.web_content_bucket_regional_domain_name
}

output "bucket_id" {
  value = module.web_content_bucket.name
}
