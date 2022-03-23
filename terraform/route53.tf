locals {
  # Both domains (root and *.domain_name format) use same cert/have duplicate cert data
  # Uses first DVO object's info for CNAME record data
  cname_record_options = tolist(aws_acm_certificate.site_ssl_cert.domain_validation_options)[0]
}

# Config for Route53 Hosted Zone and DNS records
resource "aws_route53_zone" "personal_site_hosted_zone" {
  name = var.domain_name
  comment = "HostedZone created by Route53 Registrar"
  force_destroy = false
}

resource "aws_route53_record" "site_cname_record" {
  zone_id = aws_route53_zone.personal_site_hosted_zone.zone_id
  name = local.cname_record_options.resource_record_name
  records = [local.cname_record_options.resource_record_value]
  type = local.cname_record_options.resource_record_type
  ttl = 300
}

resource "aws_route53_record" "root_a_record" {
  zone_id = aws_route53_zone.personal_site_hosted_zone.zone_id
  name = var.domain_name
  type = "A"

  alias {
    name = aws_cloudfront_distribution.s3_source_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_source_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_a_record" {
  zone_id = aws_route53_zone.personal_site_hosted_zone.zone_id
  name = "www.${var.domain_name}"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.s3_redirect_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_redirect_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
