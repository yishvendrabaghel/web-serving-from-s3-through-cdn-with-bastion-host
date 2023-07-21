locals {
  s3_origin_id="test-dev-admin"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "test-admin-OAID"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Dev"
  default_root_object = "index.html"

#   aliases = ["yishu-test-dev.kellton.net"]


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id
    
    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }


  price_class = "PriceClass_All"




  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
  cloudfront_default_certificate = true
  acm_certificate_arn = aws_acm_certificate.acm.arn
  ssl_support_method = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  }
}
resource "aws_acm_certificate" "acm" {
  private_key = file("./Certificates/kellton.key")
  certificate_body = file("./Certificates/kellton.pem")
  certificate_chain = file("./Certificates/kellton.crt")

}
output "origin_access_identity" {
    value = aws_cloudfront_origin_access_identity.origin_access_identity.id
}


output "cloudfront_dns" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

locals {
  cloudfront_dns = aws_cloudfront_distribution.s3_distribution.domain_name
}

resource "local_file" "cloudfront_dns" {
  content = "${local.cloudfront_dns}"
  filename = "dns.txt"
}
