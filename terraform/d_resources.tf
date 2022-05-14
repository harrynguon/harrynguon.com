# Pre-existing resources that have been set up in Terraform in other repo(s)

data "aws_route53_zone" "personal_domain_route53_zone" {
	name = var.domain_name
}

data "aws_acm_certificate" "domain_name_certificate" {
	provider = aws.us-east-1
	domain   = var.domain_name
	statuses = ["ISSUED"]
}