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

variable "subject_alternative_names" {
  type        = list(string)
  default     = []
  description = "DNS aliases for the cloudfront distribution."
}

variable "us_east_1_acm_certificate_arn" {
  type        = string
  default     = ""
  description = "Certificate to associate with the cloudfront distribution."
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "Domain to setup for DNS aliasing the cloudfront distribution."
}

variable "log_requests" {
  type        = bool
  default     = false
  description = "Log requests made to the cloudfront distribution to s3."
}

locals {
  web_content_bucket_regional_domain_name = "${var.bucket_name}.s3.${data.aws_region.current.name}.amazonaws.com"
}
