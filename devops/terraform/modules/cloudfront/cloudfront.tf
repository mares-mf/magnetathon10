locals {
  s3_origin_id = "s3-terraform-magnetathon-10-${var.deployment_name}"
}

# Configure cloudfront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.s3_bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = var.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.deployment_name} deployment"
  default_root_object = "index.html"
  aliases = [ "${var.deployment_name}.${var.domain_name}" ]

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
    default_ttl            = 300
    max_ttl                = 300
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.deployment_name
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"
  }
}

resource "aws_route53_record" "subdomain" {
  zone_id = var.route53_zone_id
  name    = "${var.deployment_name}.${var.domain_name}"
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}