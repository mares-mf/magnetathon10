﻿# Configure ACM Certificate
resource "aws_acm_certificate" "main_cert" {
  domain_name = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method = "DNS"
}

resource "aws_route53_record" "verification" {
  for_each = {
  for dvo in aws_acm_certificate.main_cert.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

resource "aws_acm_certificate_validation" "main_cert" {
  certificate_arn = aws_acm_certificate.main_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.verification : record.fqdn]
}