output "S3_Bucket" {
  value = module.s3.S3_Bucket
}

output "CloudFront_Domain" {
  value = module.cloudfront.CloudFront_Domain
}

output "CloudFront_Domain_Aliases" {
  value = module.cloudfront.CloudFront_Domain_Aliases
}