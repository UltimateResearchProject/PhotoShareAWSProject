provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = var.backend_bucket
    key            = "${var.project_name}/${var.environment}"
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = var.backend_lock_table
  }
}