terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "rybczyk-hashicorp"

    workspaces {
      name = "terraform-demo"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "demo" {
  bucket = "${var.bucket_prefix}-${var.environment}-demo"

  tags = {
   Environment = var.environment
   Owner       = var.owner
   ManagedBy   = "HCP-Terraform"
  }
}

# Intentionally block public access so the "good" run passes policy checks.
resource "aws_s3_bucket_public_access_block" "demo" {
  bucket = aws_s3_bucket.demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id

  versioning_configuration {
    status = "Enabled"
  }
}
