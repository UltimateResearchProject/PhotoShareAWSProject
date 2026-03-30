variable "vpc_id" {
    description = "VPC ID for security groups"
    type        = string
}

variable "alb_ingress_rules" {
    description = "Ingress rules for ALB security group"
    type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
    }))
}

variable "ec2_ingress_rules" {
    description = "Ingress rules for EC2 security group"
    type = list(object({
        from_port       = number
        to_port         = number
        protocol        = string
        security_groups = list(string)
    }))
}

variable "rds_ingress_rules" {
    description = "Ingress rules for RDS security group"
    type = list(object({
        from_port       = number
        to_port         = number
        protocol        = string
        security_groups = list(string)
    }))
}