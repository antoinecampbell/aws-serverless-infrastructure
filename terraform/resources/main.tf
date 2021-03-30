# variables
locals {
  tags = {
    Environment = var.environment
    Version = var.app_version
  }
}

variable "environment" {}
variable "region" {
  default = "us-east-1"
}
variable "zip_path" {
  default = "../../node-functions/lambda.zip"
}
variable "auth_enabled" {
  default = false
}
variable "app_version" {
  default = "latest"
}
