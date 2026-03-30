variable "subnet_id" {
    description = "The subnet ID where the EC2 instance will be launched"
    type        = string
}

variable "sg_id" {
    description = "The security group ID for the EC2 instance"
    type        = string
}

variable "key_pair_name" {
    description = "The name of the key pair for SSH access"
    type        = string
}