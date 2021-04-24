# config
terraform {
  backend "http" {
  }
}

variable "environment" {}
variable "region" {
  default = "us-east-1"
}
variable "zip_path" {
  default = "../node-functions/lambda.zip"
}
variable "auth_enabled" {
  default = false
}
variable "app_version" {
  default = "latest"
}

module "resources" {
  source = "./resources"

  environment = var.environment
  region = var.region
  zip_path = var.zip_path
  auth_enabled = var.auth_enabled
  app_version = var.app_version
}

output "notes_endpoint" {
  value = module.resources.notes_endpoint
}