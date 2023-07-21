

resource "aws_iam_role_policy_attachment" "s3_access_policy" {
  policy_arn = aws_iam_policy.s3-full-access.arn
  role       = aws_iam_role.demo-role.name
}

resource "aws_iam_policy" "s3-full-access" {
  name = "s3-full-access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}


variable "bucket_name" {}