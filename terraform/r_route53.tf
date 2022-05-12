data "aws_route53_zone" "personal_domain_route53_zone" {
	name = var.domain_name
}

#resource "aws_route53_record" "www_portfolio_website_cname" {
#	name    = "www"
#	zone_id = data.aws_route53_zone.personal_domain_route53_zone.zone_id
#	type    = "CNAME"
#
#	ttl     = 600
#	records = ["pedantic-ritchie-636456.netlify.app"]
#}

resource "aws_route53_record" "domain_name_alias_record_to_s3" {
	name    = var.domain_name
	zone_id = data.aws_route53_zone.personal_domain_route53_zone.zone_id
	type    = "A"

	alias {
		name                   = aws_s3_bucket.portfolio_website_bucket.website_endpoint
		zone_id                = aws_s3_bucket.portfolio_website_bucket.hosted_zone_id
		evaluate_target_health = false
	}
}

resource "aws_route53_record" "www_domain_name_alias_record_to_s3" {
	name    = var.www_domain_name
	zone_id = data.aws_route53_zone.personal_domain_route53_zone.zone_id
	type    = "A"

	alias {
		name                   = aws_s3_bucket.www_portfolio_website_bucket.website_endpoint
		zone_id                = aws_s3_bucket.www_portfolio_website_bucket.hosted_zone_id
		evaluate_target_health = false
	}
}