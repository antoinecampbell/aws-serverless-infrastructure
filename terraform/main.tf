# config
terraform {
  backend "http" {
  }
}

variable "environment" {}
variable "region" {
  default = "us-east-1"
}

module "resources" {
  source = "./resources"

  environment = var.environment
  region = var.region
}