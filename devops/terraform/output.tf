output "S3_Bucket" {
  value = aws_s3_bucket.magnetathon10.website_endpoint
}

output "CloudFront_Domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "CloudFront_Domain_Aliases" {
  value = aws_cloudfront_distribution.s3_distribution.aliases
}