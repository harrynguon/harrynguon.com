resource "aws_route53_record" "domain_name_alias_record_to_s3" {
	name    = var.domain_name
	zone_id = data.aws_route53_zone.personal_domain_route53_zone.zone_id
	type    = "A"

	alias {
		name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
		zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
		evaluate_target_health = false
	}
}

resource "aws_route53_record" "www_domain_name_alias_record_to_s3" {
	name    = var.www_domain_name
	zone_id = data.aws_route53_zone.personal_domain_route53_zone.zone_id
	type    = "A"

	alias {
		name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
		zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
		evaluate_target_health = false
	}
}