variable "db_username" {
    description = "The master username for the RDS instance"
    type        = string
    sensitive   = true
}

variable "db_password" {
    description = "The master password for the RDS instance"
    type        = string
    sensitive   = true
}

variable "sg_id" {
    description = "The security group ID for the RDS instance"
    type        = string
}

variable "db_subnet_group_name" {
    description = "The DB subnet group name for the RDS instance"
    type        = string
}