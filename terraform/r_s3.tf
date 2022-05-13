# Bucket for the main domain
resource "aws_s3_bucket" "portfolio_website_bucket" {
	bucket = var.domain_name
}

resource "aws_s3_bucket_website_configuration" "portfolio_website_bucket_website_configuration" {
	bucket = aws_s3_bucket.portfolio_website_bucket.bucket

	index_document {
		suffix = var.default_root_object
	}

	error_document {
		key = var.default_root_object
	}
}

resource "aws_s3_bucket_acl" "portfolio_website_bucket_acl" {
	bucket = aws_s3_bucket.portfolio_website_bucket.id
	acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "example" {
	bucket = aws_s3_bucket.portfolio_website_bucket.id

	block_public_acls   = false
	block_public_policy = false
}

data "aws_iam_policy_document" "portfolio_website_bucket_policy" {
	statement {
		principals {
			type        = "AWS"
			identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
		}

		actions   = ["s3:GetObject"]
		resources = ["${aws_s3_bucket.portfolio_website_bucket.arn}/*"]
	}
}

resource "aws_s3_bucket_policy" "portfolio_website_policy_public_access" {
	bucket = aws_s3_bucket.portfolio_website_bucket.id
	policy = data.aws_iam_policy_document.portfolio_website_bucket_policy.json
}


# www. subdomain bucket
resource "aws_s3_bucket" "www_portfolio_website_bucket" {
	bucket = var.www_domain_name
}

resource "aws_s3_bucket_website_configuration" "www_portfolio_website_bucket_website_configuration" {
	bucket = aws_s3_bucket.www_portfolio_website_bucket.bucket

	redirect_all_requests_to {
		host_name = aws_s3_bucket.portfolio_website_bucket.bucket
	}
}