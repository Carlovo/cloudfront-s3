data "aws_region" "current" {}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket"
}

variable "cloudfront_function_viewer_request_code" {
  type        = string
  default     = ""
  description = "JS code for cloudfront function upon viewer request"
}

locals {
  web_content_bucket_regional_domain_name = "${var.bucket_name}.s3.${data.aws_region.current.name}.amazonaws.com"
}
