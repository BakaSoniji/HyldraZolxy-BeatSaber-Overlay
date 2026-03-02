output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (set as CLOUDFRONT_DISTRIBUTION_ID in GitHub Actions)"
  value       = aws_cloudfront_distribution.overlay.id
}
