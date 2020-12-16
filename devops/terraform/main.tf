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

# TODO: change to upload all objects in ui/build
# Upload an object
resource "aws_s3_bucket_object" "object1" {
  bucket = aws_s3_bucket.magnetathon10.id
  key    = "index.html"
  acl    = "private"
  source = "../../ui/index.html"
  etag = filemd5("../../ui/index.html")
}