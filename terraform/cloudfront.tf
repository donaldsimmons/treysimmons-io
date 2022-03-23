# Configuration for serving website with Cloudfront
resource "aws_cloudfront_distribution" "s3_source_distribution" {
  origin {
    domain_name = aws_s3_bucket.source_bucket.website_endpoint
    origin_id = "S3-Website-${aws_s3_bucket.source_bucket.website_endpoint}"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  # Enables CF to accept requests for content
  enabled = true
  is_ipv6_enabled = true
  aliases = [var.domain_name]

  default_cache_behavior {
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "S3-Website-treysimmons.io.s3-website-us-east-1.amazonaws.com"

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site_ssl_cert.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}

resource "aws_cloudfront_distribution" "s3_redirect_distribution" {
  origin {
    domain_name = aws_s3_bucket.redirect_bucket.website_endpoint
    origin_id = "S3-Website-${aws_s3_bucket.redirect_bucket.website_endpoint}"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true
  aliases = ["www.${var.domain_name}"]

  default_cache_behavior {
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "S3-Website-${aws_s3_bucket.redirect_bucket.website_endpoint}"

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site_ssl_cert.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}
