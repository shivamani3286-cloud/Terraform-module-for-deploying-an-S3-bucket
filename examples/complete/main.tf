terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "s3_bucket" {
  source = "../.."

  bucket_name = var.bucket_name

  lifecycle_rules = [
    {
      id                                  = "retention"
      enabled                             = true
      expiration_days                     = 365
      noncurrent_version_expiration_days  = 90
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        }
      ]
    }
  ]

  tags = {
    Environment = "example"
    ManagedBy   = "terraform"
  }
}
