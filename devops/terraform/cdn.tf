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
  s3_origin_id = "s3-terraform-magnetathon-10-${var.deployment_name}"
}

# Create bucket
resource "aws_s3_bucket" "magnetathon10" {

  bucket = "s3-terraform-magnetathon10-${var.deployment_name}"
  acl    = "private"
  tags = {
    Name        = "Magnetathon10 Bucket"
    Environment = "Dev"
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
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::s3-terraform-magnetathon10-${var.deployment_name}/*"
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

resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "static content for ${var.deployment_name}"
}

# Configure cloudfront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.magnetathon10.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.deployment_name} deployment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "dev"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}