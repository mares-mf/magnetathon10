﻿output "certificate_arn" {
  value = aws_acm_certificate_validation.main_cert.certificate_arn
}