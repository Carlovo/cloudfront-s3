module "request_log_bucket" {
  count = var.log_requests ? 1 : 0

  source = "github.com/schubergphilis/terraform-aws-mcaf-s3?ref=v0.10.0"

  name                  = "logging-${var.bucket_name}"
  object_ownership_type = "BucketOwnerPreferred"

  lifecycle_rule = [{
    id     = "delete-old"
    status = "Enabled"

    expiration = {
      days = 200
    }

    noncurrent_version_expiration = {
      noncurrent_days = 10
    }

    abort_incomplete_multipart_upload = {
      days_after_initiation = 1
    }
  }]
}
