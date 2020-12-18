locals {
  mime_types = {
    htm   = "text/html"
    html  = "text/html"
    css   = "text/css"
    ttf   = "font/ttf"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
    ico = "image/png"
    svg = "image/svg+xml"
  }
}

# Get caller information
data "aws_caller_identity" "current" {}

# Create bucket
resource "aws_s3_bucket" "magnetathon10" {

  bucket = "s3-terraform-magnetathon10-${var.deployment_name}"
  acl    = "private"
  tags = {
    Name        = "Magnetathon10 Bucket for ${var.deployment_name}"
    Environment = var.deployment_name
  }

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

# Create static site bucket policy
resource "aws_s3_bucket_policy" "static_site" {
  bucket = aws_s3_bucket.magnetathon10.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "bucket_policy_site",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.iam_arn}"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.magnetathon10.arn}/*"
        },
        {
            "Sid": "GiveSESPermissionToWriteEmail",
            "Effect": "Allow",
            "Principal": {
                "Service": "ses.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.magnetathon10.arn}/*",
            "Condition": {
                "StringEquals": {
                    "aws:Referer": "${data.aws_caller_identity.current.id}"
                }
            }
        }
    ]
}
POLICY
}

# Upload static files to S3
resource "aws_s3_bucket_object" "dist" {
  for_each = fileset("../../ui/magnetathon/out/", "**")
  bucket = aws_s3_bucket.magnetathon10.id
  key = each.value
  source = "../../ui/magnetathon/out/${each.value}"
  etag = filemd5("../../ui/magnetathon/out/${each.value}")
  content_type  = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}