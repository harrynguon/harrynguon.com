terraform {
	backend "s3" {
		bucket = "terraform-states-hub"
		key    = "projects/portfolio-web/terraform/terraform.tfstate"
		region = "ap-southeast-2"
	}

	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = ">= 4.12.1"
		}
	}
}

provider "aws" {
	region = "ap-southeast-2"
	assume_role {
		role_arn     = "arn:aws:iam::${var.account_id}:role/Terraform-Admin"
		session_name = "terraform-harry"
	}

	default_tags {
		tags = {
			Owner             = "Harry"
			Description       = "Personal portfolio website resources"
			GitRepositoryName = "Portfolio-Website"
			ManagedBy         = "Terraform"
		}
	}
}