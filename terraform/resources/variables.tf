variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "db_username" {
  description = "Database username"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}

variable "key_pair_name" {
  description = "EC2 key pair"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS"
}

variable "enable_nat_gateway" {
  description = "Enable NAT (costly)"
  default     = false
}