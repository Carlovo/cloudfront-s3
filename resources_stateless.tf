module "web_content_bucket" {
  source = "github.com/schubergphilis/terraform-aws-mcaf-s3?ref=v0.10.0"
  name   = var.bucket_name
  policy = data.aws_iam_policy_document.web_content_bucket.json
}
