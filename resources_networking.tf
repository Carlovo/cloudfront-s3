data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = var.subject_alternative_names

  origin {
    domain_name              = local.web_content_bucket_regional_domain_name
    origin_id                = local.web_content_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
    target_origin_id       = local.web_content_bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    dynamic "function_association" {
      for_each = var.cloudfront_function_viewer_request_code != "" ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.viewer_request[0].arn
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 10
  }

  # conditional nested blocks are not supported by Terraform, therefore this hack
  dynamic "viewer_certificate" {
    for_each = var.us_east_1_acm_certificate_arn == "" ? [1] : []

    content {
      cloudfront_default_certificate = true
    }
  }

  dynamic "viewer_certificate" {
    for_each = var.us_east_1_acm_certificate_arn == "" ? [] : [1]

    content {
      acm_certificate_arn      = var.us_east_1_acm_certificate_arn
      ssl_support_method       = "sni-only"
      minimum_protocol_version = "TLSv1.2_2019"
    }
  }
}

resource "aws_cloudfront_function" "viewer_request" {
  count = var.cloudfront_function_viewer_request_code != "" ? 1 : 0

  name    = var.bucket_name
  runtime = "cloudfront-js-1.0"
  code    = var.cloudfront_function_viewer_request_code
}

data "aws_route53_zone" "selected" {
  count = var.domain_name == "" ? 0 : 1

  name = var.domain_name
}

module "alias_a_records" {
  for_each = var.domain_name == "" ? [] : toset(var.subject_alternative_names)

  source = "github.com/Carlovo/route53-alias-records"

  dns_record_name = each.key

  hosted_zone_id       = data.aws_route53_zone.selected[0].zone_id
  alias_domain_name    = aws_cloudfront_distribution.this.domain_name
  alias_hosted_zone_id = aws_cloudfront_distribution.this.hosted_zone_id
}
