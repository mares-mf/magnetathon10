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
