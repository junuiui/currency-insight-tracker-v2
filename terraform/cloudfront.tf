# CloudFront가 S3에 안전하게 접근하기 위한 제어 장치 (OAC)
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "frontend-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id                = "S3-Frontend-Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  origin {
    domain_name = aws_lb.main.dns_name # 우리 ALB 주소
    origin_id   = "ALB-Backend-Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # CF에서 ALB로 갈 때는 HTTP로 통신
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-Backend-Origin"

    forwarded_values {
      query_string = true
      headers      = ["Origin", "Authorization", "Accept"] # CORS 및 API 요청에 필요한 헤더 전달
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "https-only"
    compress               = true
    min_ttl                = 0
    default_ttl            = 0 # API 데이터이므로 캐싱하지 않음
    max_ttl                = 0
  }

  # 기본 캐시 설정
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Frontend-Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https" # HTTP로 들어와도 HTTPS로 강제 전환
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # React/Vue 같은 SPA를 위한 핵심 설정 (404 발생 시 index.html로 리다이렉트)
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "currency-v2-frontend-cdn"
  }
}

# 나중에 접속할 CloudFront 도메인 주소 출력
output "frontend_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
