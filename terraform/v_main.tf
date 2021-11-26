variable "account_id" {
  type = number
}

variable "tags" {
  type = map(string)
  
  default = {
    Owner = "Harry"
    AppName = "portfolio-web"
    ManagedBy = "Terraform"
  }
}