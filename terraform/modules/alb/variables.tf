variable "vpc_id" {
    description = "VPC ID where the target group will be created"
    type        = string
}

variable "target_group_name" {
    description = "Name of the target group"
    type        = string
    default     = "photoshare-tg"
}

variable "target_group_port" {
    description = "Port for the target group"
    type        = number
    default     = 80
}

variable "health_check_path" {
    description = "Health check path"
    type        = string
    default     = "/"
}

variable "health_check_matcher" {
    description = "Health check HTTP matcher status codes"
    type        = string
    default     = "200"
}

variable "health_check_interval" {
    description = "Health check interval in seconds"
    type        = number
    default     = 30
}

variable "health_check_timeout" {
    description = "Health check timeout in seconds"
    type        = number
    default     = 5
}

variable "listener_port" {
    description = "Port for the load balancer listener"
    type        = number
    default     = 80
}

variable "listener_protocol" {
    description = "Protocol for the load balancer listener"
    type        = string
    default     = "HTTP"
}

variable "healthy_threshold" {
    description = "Number of consecutive health checks successes required before considering an unhealthy target healthy"
    type        = number
    default     = 3
}

variable "unhealthy_threshold" {
    description = "Number of consecutive health check failures required before considering a target unhealthy"
    type        = number
    default     = 3
}

variable "target_group_protocol" {
    description = "Protocol for the target group"
    type        = string
    default     = "HTTP"
}

variable "health_check_protocol" {
    description = "Protocol for the health check"
    type        = string
    default     = "HTTP"
}

variable "public_subnet_ids" {
  description = "Public subnets for ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group for ALB"
  type        = list(string)
}

variable "ec2_instance_id" {
  description = "EC2 instance ID to attach to ALB"
  type        = string
}