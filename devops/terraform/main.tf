terraform {
  backend "s3" {
    bucket = "magnetathon10-seed-1-and-2"
    key    = "magnetathon10/terraform_state"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create bucket
resource "aws_s3_bucket" "magnetathon10" {

  bucket = "s3-terraform-magnetathon10"
  acl    = "private"
  tags = {
    Name        = "Magnetathon10 Bucket"
    Environment = "Dev"
  }
}

#upload everything in dist
resource "aws_s3_bucket_object" "dist" {
  for_each = fileset("../../ui/magnetathon/.next/", "*")
  bucket = aws_s3_bucket.magnetathon10.id
  key = each.value
  source = "../../ui/magnetathon/.next/${each.value}"
  etag = filemd5("../../ui/magnetathon/.next/${each.value}")
}
