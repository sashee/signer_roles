output "bucket" {
  value = aws_s3_bucket.bucket.bucket
}

output "role" {
  value = aws_iam_role.role.arn
}

