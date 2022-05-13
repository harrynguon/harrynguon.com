variable "account_id" {
	type = number
}

variable "domain_name" {
	type    = string
	default = "harrynguon.com"
}

variable "www_domain_name" {
	type    = string
	default = "www.harrynguon.com"
}

variable "default_root_object" {
	type    = string
	default = "index.html"
}