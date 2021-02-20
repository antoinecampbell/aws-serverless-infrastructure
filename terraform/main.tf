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
  default = "../"
}

module "resources" {
  source = "./resources"

  environment = var.environment
  region = var.region
  zip_path = var.zip_path
}