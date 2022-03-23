# Config for AWS Certificate Manager SSL Certs
resource "aws_acm_certificate" "site_ssl_cert" {
  domain_name = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]
  lifecycle {
    create_before_destroy = true
  }
}
