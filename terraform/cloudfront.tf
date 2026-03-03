# =============================================================================
# ACM Certificate (us-east-1 for CloudFront)
# =============================================================================

data "aws_route53_zone" "main" {
  name = var.route53_zone_name
}

resource "aws_acm_certificate" "overlay" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.overlay.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "overlay" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.overlay.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# =============================================================================
# Origin Access Control
# =============================================================================

resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = "${var.s3_bucket_name}-oac"
  description                       = "OAC for ${var.domain_name} S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# =============================================================================
# CloudFront Functions
# =============================================================================

resource "aws_cloudfront_function" "scoresaber_proxy" {
  name    = "hyldrazolxy-overlay-scoresaber-proxy"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/cloudfront-functions/scoresaber-proxy.js")
}

resource "aws_cloudfront_function" "scoresaber_cors" {
  name    = "hyldrazolxy-overlay-scoresaber-cors"
  runtime = "cloudfront-js-2.0"
  publish = true
  code = templatefile("${path.module}/cloudfront-functions/scoresaber-cors.js", {
    allowed_origin = var.domain_name
  })
}

# =============================================================================
# Custom Cache Policy for ScoreSaber API (120s TTL)
# =============================================================================

resource "aws_cloudfront_cache_policy" "scoresaber_api" {
  name        = "hyldrazolxy-overlay-scoresaber-api-120s"
  comment     = "120s cache for ScoreSaber API proxy"
  default_ttl = 120
  max_ttl     = 120
  min_ttl     = 120

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Origin"]
      }
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

# =============================================================================
# CloudFront Distribution
# =============================================================================

resource "aws_cloudfront_distribution" "overlay" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.domain_name} - BeatSaber streaming overlay"
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  aliases             = [var.domain_name]

  # Origin 1: S3 bucket for static files
  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "s3-site"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }

  # Origin 2: ScoreSaber API
  origin {
    domain_name = "scoresaber.com"
    origin_id   = "scoresaber-api"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # ScoreSaber API cache behavior (must be before default)
  ordered_cache_behavior {
    path_pattern     = "/api/scoresaber/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "scoresaber-api"

    cache_policy_id = aws_cloudfront_cache_policy.scoresaber_api.id

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.scoresaber_proxy.arn
    }

    function_association {
      event_type   = "viewer-response"
      function_arn = aws_cloudfront_function.scoresaber_cors.arn
    }
  }

  # Default behavior: S3 static files
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-site"

    # Managed cache policy: CachingOptimized
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.overlay.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  depends_on = [aws_acm_certificate_validation.overlay]
}

# =============================================================================
# Route53 Record
# =============================================================================

resource "aws_route53_record" "overlay" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.overlay.domain_name
    zone_id                = aws_cloudfront_distribution.overlay.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "overlay_ipv6" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.overlay.domain_name
    zone_id                = aws_cloudfront_distribution.overlay.hosted_zone_id
    evaluate_target_health = false
  }
}
