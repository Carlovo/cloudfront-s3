output "cloudfront_endpoint" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.this.hosted_zone_id
}

output "bucket_regional_domain_name" {
  value = local.web_content_bucket_regional_domain_name
}

output "bucket_id" {
  value = module.web_content_bucket.name
}
