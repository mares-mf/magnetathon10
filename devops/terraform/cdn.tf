resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "static content for ${var.deployment_name}"
}

module "s3" {
  source = "./modules/s3"

  deployment_name = var.deployment_name
  domain_name = var.domain_name
  iam_arn = aws_cloudfront_origin_access_identity.website.iam_arn
}

module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name
  route53_zone_id = var.route53_zone_id
}

module "cloudfront" {
  source = "./modules/cloudfront"

  domain_name = var.domain_name
  route53_zone_id = var.route53_zone_id
  deployment_name = var.deployment_name
  s3_bucket_regional_domain_name = module.s3.s3_bucket_regional_domain_name
  acm_certificate_arn = module.acm.certificate_arn
  cloudfront_access_identity_path = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
}