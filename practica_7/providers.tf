terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.2.0, <6.7.0, !=6.4.0"
    }
  }
  required_version = "~>1.12.0"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  default_tags {
    tags = var.tags
  }
}
