variable "role_arn" {
    description = "ARN of the IAM role for Lambda execution"
    type        = string
}

variable "subnet_id" {
    description = "Subnet ID for Lambda VPC configuration"
    type        = string
}

variable "sg_id" {
    description = "Security group ID for Lambda VPC configuration"
    type        = string
}