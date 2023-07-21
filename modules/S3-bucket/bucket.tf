
######
resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket-name
  force_destroy = true
}
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "OnlyCloudfrontReadAccess",
          "Principal": {
            "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.origin_access_identity}"
          },
          "Effect": "Allow",
          "Action": [
            "s3:GetObject"
          ],
          "Resource": "arn:aws:s3:::${var.bucket-name}/*"
        }
      ]
    }
  EOF
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
######



output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}
output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}


output "website_endpoint" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}
#######