terraform {
  backend "s3" {
    bucket = "terraform-states-hub"
    key = "projects/portfolio-web/terraform/terraform.tfstate"
    region = "ap-southeast-2"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/Terraform-Admin"
    session_name = "terraform-harry"
  }
}

resource "aws_route53_zone" "primary" {
  name = "harrynguon.com"

  tags = var.tags
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id

  name = "www"
  type = "CNAME"
  ttl = "300"
  
  records = ["pedantic-ritchie-636456.netlify.app"]
  
}