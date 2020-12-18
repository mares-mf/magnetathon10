output "s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.magnetathon10.bucket_regional_domain_name
}

output "S3_Bucket" {
  value = aws_s3_bucket.magnetathon10.website_endpoint
}