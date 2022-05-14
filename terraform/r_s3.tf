﻿# Bucket for the main domain
resource "aws_s3_bucket" "portfolio_website_bucket" {
	bucket = var.domain_name
}

resource "aws_s3_bucket_acl" "portfolio_website_bucket_acl" {
	bucket = aws_s3_bucket.portfolio_website_bucket.id
	acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "portfolio_website_bucket_public_access_block" {
	bucket = aws_s3_bucket.portfolio_website_bucket.id

	block_public_acls       = true
	block_public_policy     = true
	ignore_public_acls      = true
	restrict_public_buckets = true
}

data "aws_iam_policy_document" "portfolio_website_bucket_policy_document" {
	statement {
		principals {
			type        = "AWS"
			identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
		}

		actions   = ["s3:GetObject"]
		resources = ["${aws_s3_bucket.portfolio_website_bucket.arn}/*"]
	}
}

resource "aws_s3_bucket_policy" "portfolio_website_bucket_policy" {
	bucket = aws_s3_bucket.portfolio_website_bucket.id
	policy = data.aws_iam_policy_document.portfolio_website_bucket_policy_document.json
}