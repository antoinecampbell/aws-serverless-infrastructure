# variables
locals {
  tags = {
    Environment = var.environment
  }
}

variable "environment" {}
variable "region" {
  default = "us-east-1"
}

