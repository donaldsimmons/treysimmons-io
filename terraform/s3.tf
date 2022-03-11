# s3 bucket configs for hosting site
resource "aws_s3_bucket" "source_bucket" {
  bucket = var.domain_name
}

resource "aws_s3_bucket_acl" "source_bucket_acl" {
  bucket = aws_s3_bucket.source_bucket.id
  acl = "public-read"
}

# CORS rules for Cloudfront - Enables compression for faster load
resource "aws_s3_bucket_cors_configuration" "source_cors_config" {
  bucket = aws_s3_bucket.source_bucket.id
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.domain_name}"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "source_bucket_policy" {
  bucket = aws_s3_bucket.source_bucket.id
  policy = data.aws_iam_policy_document.source_bucket_policy_document.json
}

data "aws_iam_policy_document" "source_bucket_policy_document" {
  statement {
    sid = "AllowSiteRead"
    effect = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    }
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::treysimmons.io/index.html",
      "arn:aws:s3:::treysimmons.io/styles.css",
      "arn:aws:s3:::treysimmons.io/main.js",
      "arn:aws:s3:::treysimmons.io/images/*",
      "arn:aws:s3:::treysimmons.io/files/*"
    ]
  }
}

# Source config for treysimmons.io website
resource "aws_s3_bucket_website_configuration" "source_website_config" {
  bucket = aws_s3_bucket.source_bucket.id
  index_document {
    suffix = "index.html"
  }
}

# Config for redirect 'www' traffic to 'non-www' source
resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "www.${var.domain_name}"
}

resource "aws_s3_bucket_website_configuration" "redirect_website_config" {
  bucket = aws_s3_bucket.redirect_bucket.id
  redirect_all_requests_to {
    host_name = var.domain_name
    protocol = "https"
  }
}
