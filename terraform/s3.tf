# 프론트엔드 정적 파일을 저장할 S3 버킷
resource "aws_s3_bucket" "frontend" {
  bucket = "currency-v2-frontend-${random_string.suffix.result}"
}

# 버킷 이름 중복 방지를 위한 랜덤 문자열
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 버킷에 대한 모든 퍼블릭 액세스 차단 (보안 정석)
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront만 S3 파일에 접근할 수 있도록 허용하는 정책
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.frontend.arn}/*"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}
