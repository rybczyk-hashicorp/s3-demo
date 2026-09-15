variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name (must be globally unique)"
  type        = string
  default     = "hcp-tf-interview"
}

variable "environment" {
  description = "Environment tag, e.g. demo, dev, prod"
  type        = string
  default     = "demo"
}

variable "owner" {
  description = "Owner tag for the resource"
  type        = string
  default     = "your-name"
}
