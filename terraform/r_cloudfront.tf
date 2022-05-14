locals {
	origin_id = "origin-for-${var.domain_name}"
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
	enabled         = true
	is_ipv6_enabled = true

	comment             = "CloudFront distribution for ${var.domain_name}"
	default_root_object = var.default_root_object

	aliases = [var.domain_name, var.www_domain_name]

	origin {
		domain_name = aws_s3_bucket.portfolio_website_bucket.bucket_regional_domain_name
		origin_id   = local.origin_id

		s3_origin_config {
			origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
		}
	}

	default_cache_behavior {
		target_origin_id       = local.origin_id
		allowed_methods        = ["GET", "HEAD"]
		cached_methods         = ["GET", "HEAD"]
		viewer_protocol_policy = "redirect-to-https"

		cache_policy_id          = aws_cloudfront_cache_policy.cloudfront_cache_policy.id
		origin_request_policy_id = aws_cloudfront_origin_request_policy.cloudfront_origin_request_policy.id
	}

	restrictions {
		geo_restriction {
			restriction_type = "none"
		}
	}

	custom_error_response {
		error_code            = 403
		error_caching_min_ttl = 300
		response_page_path    = "/index.html"
		response_code         = 200
	}

	custom_error_response {
		error_code            = 404
		error_caching_min_ttl = 300
		response_page_path    = "/index.html"
		response_code         = 200
	}

	price_class = "PriceClass_200"

	viewer_certificate {
		acm_certificate_arn      = data.aws_acm_certificate.domain_name_certificate.arn
		ssl_support_method       = "sni-only"
		minimum_protocol_version = "TLSv1.2_2021"
	}
}

# Cache policy for the CloudFront Behaviour setting
# No caching
resource "aws_cloudfront_cache_policy" "cloudfront_cache_policy" {
	name = "CF-Cache-Policy-Portfolio-Website"

	default_ttl = 0
	min_ttl     = 0
	max_ttl     = 0

	parameters_in_cache_key_and_forwarded_to_origin {
		cookies_config {
			cookie_behavior = "none"
		}

		headers_config {
			header_behavior = "none"
		}

		query_strings_config {
			query_string_behavior = "none"
		}

		enable_accept_encoding_brotli = false
		enable_accept_encoding_gzip   = false
	}

}

# Origin access policy for the CloudFront Behaviour setting
# Allows CORS
resource "aws_cloudfront_origin_request_policy" "cloudfront_origin_request_policy" {
	name = "CF-Origin-Request-Policy-Portfolio-Website"

	cookies_config {
		cookie_behavior = "none"
	}

	headers_config {
		header_behavior = "whitelist"
		headers {
			items = [
				"origin",
				"access-control-request-headers",
				"access-control-request-method"
			]
		}
	}

	query_strings_config {
		query_string_behavior = "none"
	}
}

# Origin access identity (OAI) to restrict s3 access
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
	comment = "Origin-Access-Identity-for-CF-${var.domain_name}"
}