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

#upload everything in dist
resource "aws_s3_bucket_object" "dist" {
  for_each = fileset("../../ui/magnetathon/out/", "**")
  bucket = aws_s3_bucket.magnetathon10.id
  key = each.value
  source = "../../ui/magnetathon/out/${each.value}"
  etag = filemd5("../../ui/magnetathon/out/${each.value}")
  content_type  = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}
