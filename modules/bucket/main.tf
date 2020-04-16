variable "file" {
  type = string
}

variable "trusted_role" {
  type = string
}

resource "aws_s3_bucket" "bucket" {
  force_destroy = "true"
}

resource "aws_s3_bucket_object" "cat" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "cat.jpg"
  source = var.file
}

data "aws_iam_policy_document" "bucket-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.trusted_role]
    }
  }
}

data "aws_iam_policy_document" "bucket-role-policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "bucket-role-policy" {
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.bucket-role-policy.json
}

resource "aws_iam_role" "role" {
  assume_role_policy = data.aws_iam_policy_document.bucket-assume-role-policy.json
}

output "bucket" {
  value = aws_s3_bucket.bucket.bucket
}

output "role" {
  value = aws_iam_role.role.arn
}
