variable "domain_name" {
  description = "Domain name for the overlay site (e.g., hyldrazolxy-overlay.bakas.io)"
  type        = string
}

variable "route53_zone_name" {
  description = "Route53 hosted zone name (e.g., bakas.io)"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for site content"
  type        = string
}
