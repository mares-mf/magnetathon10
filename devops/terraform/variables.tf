variable "deployment_name" {
  description = "Name of deployment"
  default = "dev"
}

variable "domain_name" {
  description = "Name of domain"
  default = "magnetathon-mm.click"
}

variable "route53_zone_id" {
  description = "Hosted zone ID"
  default = "Z04922071MH9V1KM2YWLG"
}

variable "subdomain_acm_certificate_arn" {
  description = "ARN of SSL Certificate for domain"
  default = "arn:aws:acm:us-east-1:934500947005:certificate/c182edc2-0d9e-4e01-8d92-d3169e1d79f9"
}